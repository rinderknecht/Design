let file = ref "" (* Name of the scanned file  (set by [scan]) *)

type loc = int * int (* line, column *)

type kwd =
  ALL | AUTOMATIC | BEGIN | DEFINITIONS | END | EXPLICIT | EXPORTS
| EXTENSIBILITY | FROM | IMPLICIT | IMPLIED | IMPORTS | TAGS

type sym =
  Assign | Lbrace | Rbrace | Comma | Lparen | Rparen | SemiColon

type token = private
  Low     of (loc * string)  (* lowercase ([hyphen] (letter | digit))*    *)
| Up      of (loc * string)  (* uppercase ([hyphen] uppercase)*           *)
| ModRef  of (loc * string)  (* Module reference *)
| Nat     of (loc * string)  (* Natural number *)
| Str     of (loc * string)  (* String *)
| Kwd     of (loc * kwd)     (* Keyword *)
| Sym     of (loc * sym)     (* Symbol *)
| EOF     of loc             (* End of file (virtual token) *)

let string_of_sym = function
  Assign -> "::=" | Lbrace -> "{" | Rbrace -> "}" | Comma -> ","
| Lparen -> "(" | Rparen -> ")" | SemiColon -> ";"

let string_of_kwd = function
  ALL -> "ALL" | AUTOMATIC -> "AUTOMATIC" | BEGIN -> "BEGIN"
| DEFINITIONS -> "DEFINITIONS" | END -> "END" | EXPLICIT -> "EXPLICIT"
| EXPORTS -> "EXPORTS" | EXTENSIBILITY -> "EXTENSIBILITY"
| FROM -> "FROM" | IMPLICIT -> "IMPLICIT" | IMPLIED -> "IMPLIED"
| IMPORTS -> "IMPORTS" | TAGS -> "TAGS"

(* Auxiliary parser combinators *)

(* In [opt p] and [star p], the parser [p] must not parse nothing. For
   the LL(1) property to hold, the token following [opt p] and [star
   p] must not be accepted by [p]. *)

let opt p = parser [< x=p >] -> Some x | [<>] -> None

let rec star p = parser [< x=p; y=star p >] -> x::y
                      |                [<>] -> []

(* Parser modes: [Fail] means that [Stream.Failure] must be raised
   again; [Abort] means that a [Stream.Failure] is a syntax error. *)

type mode = Fail | Abort

(* At the head of a stream pattern, use [plus p Fail]; otherwise
   [plus p Abort]. *)

let plus p m = parser [< x=p m; y=star (p Fail) >] -> x::y 

(* Syntax errors *)

exception Error of (loc * string)  (* Location, message *)

let get_loc = function
  Low (loc,_)    | Up (loc,_) | ModRef (loc,_)
| Str (loc,_)  | Nat (loc,_)
| Sym (loc,_)  | Kwd (loc,_) | EOF loc -> loc

let stop token msg = raise (Error (get_loc token, msg))

let check msg = function
   Fail -> (parser [<>] -> raise Stream.Failure)
| Abort -> parser [< 't >] -> stop t msg

(* Parsing individual tokens (with errors). *)

let modref = parser
  [< 'ModRef _ >] -> ()
| [< 't >] -> stop t "Module reference expected."

let kwd k = parser
  [< 'Kwd (_,k') when k=k' >] -> ()
| [< 't >] -> stop t ("Keyword " ^ string_of_kwd k ^ " expected.")

let sym s = parser
  [< 'Sym (_,s') when s=s' >] -> ()
| [< 't >] -> stop t ("Symbol " ^ string_of_sym s ^ " expected.")

let nat = parser [< 'Nat _ >] -> ()
               | [< 't >] -> stop t "Natural number expected."

(* Parsing a stream of tokens *)

let rec moduleDefinition = parser
  [< _=moduleIdentifier;
     ()=kwd DEFINITIONS;
     _=opt tagDefault;
     _=opt extensionDefault;
     ()=sym Assign;
     ()=kwd BEGIN;
     s=moduleSuffix >] -> s

and moduleIdentifier = parser
  [< 'ModRef _; _=opt definitiveIdentification >] -> ()
| [< 't >] -> stop t "Module identifier expected"

and definitiveIdentification = parser
  [< 'Sym (_,Lbrace); _=plus definitiveObjIdComponent Abort;
     ()=sym Rbrace; _=opt iriValue >] -> ()

and iriValue = parser [< 'Str _ >] -> ()

and definitiveObjIdComponent mode = parser
  [< 'Nat _ >] -> ()
| [< 'Low _; _=opt num >] -> ()
| [< s >] -> check "OID component expected." mode s

and num = parser
  [< 'Sym (_,Lparen); ()=nat; ()=sym Rparen >] -> ()

and tagDefault = parser
  [< 'Kwd (_,EXPLICIT);  ()=kwd TAGS >] -> ()
| [< 'Kwd (_,IMPLICIT);  ()=kwd TAGS >] -> ()
| [< 'Kwd (_,AUTOMATIC); ()=kwd TAGS >] -> ()

and extensionDefault = parser
  [< 'Kwd (_,EXTENSIBILITY); ()=kwd IMPLIED >] -> ()

and moduleSuffix = parser
  [< 'Kwd (_,EXPORTS); _=opt exports; ()=sym SemiColon;
     _=opt imports; a=assignmentList >] -> a
|     [< _=imports; a=assignmentList >] -> a
|                [< a=assignmentList >] -> a

and exports = parser [< _=symbolList Fail >] -> ()
                   |      [< 'Kwd (_,ALL) >] -> ()

and imports = parser
  [< 'Kwd (_,IMPORTS); _=opt imp1; ()=sym SemiColon >] -> ()

and imp1 = parser [< _=symbolList Fail; _=from >] -> ()

and from = parser [< ()=kwd FROM; _=modref; _=opt imp2 >] -> ()

and imp2 = parser
  [< _=obj; _=opt imp1 >] -> ()
| [< 'Up _; _=opt braces; _=opt moreSymbols; _=from >] -> ()
| [< 'Low _; _=opt imp3 >] -> ()

and obj = parser
  [< 'Sym (_,Lbrace); _=plus objIdComponents Abort;
     ()=sym Rbrace >] -> ()

and braces = parser [< 'Sym (_,Lbrace); ()=sym Rbrace >] -> ()

and moreSymbols = parser
  [< 'Sym (_,Comma); _=symbolList Abort >] -> ()

and imp3 = parser
  [< _=braces; _=opt moreSymbols; _=from >] -> ()
|               [< _=moreSymbols; _=from >] -> ()
| [< 'Kwd (_,FROM); _=modref; _=opt imp2 >] -> ()
|                              [< _=imp1 >] -> ()

and objIdComponents mode = parser
                            [< _=obj >] -> ()
| [< _=definitiveObjIdComponent Fail >] -> ()
| [< s >] -> check "OID component expected." mode s

and symbolList mode = parser
  [< _=symbol; _=opt moreSymbols >] -> ()
| [< s >] -> check "Reference expected." mode s

and symbol = parser [< _=reference; _=opt braces >] -> ()

and reference = parser [< 'Up _ >] -> () | [< 'Low _ >] -> ()

and assignmentList = parser
  [< 'Kwd(_,END); s >] -> after_END s
|  [< 'EOF _ as eof >] -> stop eof "Keyword END expected."
|          [< 't; s >] -> [< 't; assignmentList s >]

and after_END = parser
  [< 'EOF _ as eof >] -> [< 'eof >]
|            [< 't >] -> stop t "End of file expected."

