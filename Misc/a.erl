-module(a).
-compile(export_all).

fail0(_,0) -> -1;
fail0(X,I) -> 1 + fp0(X,nth(X,I-1),fail0(X,I-1)).

nth([A|_],0) -> A;
nth([_|X],I) -> nth(X,I-1).

fp0(_,_,-1) -> -1;
fp0(X,A, K) -> case nth(X,K) of
                A -> K;
                _ -> fp0(X,A,fail0(X,K))
              end.    

fail(        _,0) -> -1;
fail([{A,K}|X],I) -> fp(X,A,K,I-1).

fp(_,_,-1,_) -> 0;
fp(X,A, K,I) -> case suf(X,I-K-1) of
                  [{A,_}|_] -> K + 1;
                  [{_,J}|Q] -> fp(Q,A,J,K)
                end.

suf(    X,0) -> X;
suf([_|X],I) -> suf(X,I-1).

pp(X) -> pp(X,[],0).

pp(   [],_,_) -> [];
pp([A|X],P,I) -> U={A,fail(P,I)}, [U|pp(X,[U|P],I+1)].

rev(P) -> rcat(P,[]).

rcat([],Q)    -> Q;
rcat([X|P],Q) -> rcat(P,[X|Q]).

mp(P,T) -> PP=pp(P), mp(PP,T,PP,0,0).

mp(        [],    _, _,I,J) -> {factor,J-I};
mp(         _,   [], _,_,_) -> absent;
mp( [{A,_}|P],[A|T],PP,I,J) -> mp(P,T,PP,I+1,J+1);
mp([{_,-1}|_],[_|T],PP,0,J) -> mp(PP,T,PP,0,J+1);
mp( [{_,K}|_],    T,PP,_,J) -> mp(suf(PP,K),T,PP,K,J).

bst(T) -> case bst(T,infty) of false -> false;
                                   _ -> true
          end.

bst(ext,M)           -> M;
bst({bst,X,T1,T2},M) -> case bst(T2,M) of
                                 infty -> bst(T1,X);
                          N when N > X -> bst(T1,X);
                                     _ -> false
                        end.


% Andersson's search
% {bst,17,{bst,5,{bst,3,ext,ext},{bst,11,ext,{bst,13,ext,ext}}},{bst,29,ext,ext}}

mem3(Y,T) -> mem4(Y,T,T).

mem4(Y,  {bst,X,T1,_},          T) when X > Y -> mem4(Y,T1,T);
mem4(Y,C={bst,_,_,T2},          _)            -> mem4(Y,T2,C);
mem4(Y,           ext,{bst,Y,_,_})            -> true;
mem4(_,           ext,          _)            -> false.


cat([],T) -> T;
cat([X|S],T) -> [X|cat(S,T)].

rev0([]) -> [];
rev0([X|S]) -> cat(rev0(S),[X]).

sfst([],X) -> [];
sfst([X|S],X) -> S;
sfst([Y|S],X) -> [Y|sfst(S,X)].

sfst0(S,X) -> sfst(S,X,[],S).

sfst([],X,T,U) -> U;
sfst([X|S],X,T,U) -> rcat(T,S);
sfst([Y|S],X,T,U) -> sfst(S,X,[Y|T],U).

sfst1(S,X) -> sfst2(S,X,[],S).

sfst2([],X,T,U) -> U;
sfst2([X|S],X,T,U) -> cat(T,S);
sfst2([Y|S],X,T,U) -> sfst2(S,X,cat(T,[Y]),U).

slst([],X) -> [];
slst([X|S],X) -> slst(S,X,S);
slst([Y|S],X) -> [Y|slst(S,X)].

slst([],X,T) -> T;
slst([X|S],X,T) -> [X|slst(T,X)];
slst([Y|S],X,T) -> slst(S,X,T).

flat0([]) -> [];
flat0([[]|T]) -> flat0(T);
flat0([[X|S]|T]) -> cat(flat0([X|S]),flat0(T));
flat0([Y|T]) -> [Y|flat0(T)].

flat([]) -> [];
flat([[]|T]) -> flat(T);
flat([[X|S]|T]) -> flat([X,S|T]);
flat([Y|T]) -> [Y|flat(T)].

enq(X,{q,R,F}) -> {q,[X|R],F}.

deq({q,[X|R],[]}) -> deq({q,[],rcat(R,[X])});
deq({q,R,[X|F]}) -> {{q,R,F},X}.

flat1([]) -> [];
flat1([[]|T]) -> flat1(T);
flat1([[X]|T]) -> flat1([X|T]);
flat1([[X|S]|T]) -> flat1([X,S|T]);
flat1([Y|T]) -> [Y|flat1(T)].

nxt({q,[X|R],[]}) -> nxt({q,[],rcat(R,[X])});
nxt({q,R,[X|F]}) -> X.

cut(S,0) -> {[],S};
cut([X|S],K) -> push__(X,cut(S,K-1)).

push__(X,{T,U}) -> {[X|T],U}.

% Ajout
%
cut0(S,0) -> {[],S};
cut0([X|S],K) -> {T,U}=cut(S,K-1), {[X|T],U}.
%---

red([]) -> [];
red([X,X|S]) -> red([X|S]);
red([X|S]) -> [X|red(S)].

%%
% a:push(4,a:pop(a:push(3,a:push(2,a:push(1,[])))))

push(X,     []) -> [[X],[]];
push(X,H=[S|_]) -> [[X|S]|H].
pop(T=[[X|S]|_]) -> [S|T].
top([[X|_]|_]) -> X.

ver(0,[S|H]) -> S;
ver(K,[S|H]) -> ver(K-1,H).

%%
% [{push,4},pop,{push,3},{push,2},{push,1}]

ver0(0,    H) -> lst0(H);
ver0(K,[S|H]) -> ver0(K-1,H).

lst0(          []) -> [];
lst0([{push,X}|H]) -> [X|lst0(H)];
lst0(     [pop|H]) -> [_|S]=lst0(H), S.

pop0(H) -> [pop|H].
top0(H) -> top0(0,H).
top0(0,[{push,X}|H]) -> X;
top0(K,[{push,X}|H]) -> top0(K-1,H);
top0(K,     [pop|H]) -> top0(K+1,H).

lst1(H) -> lst1(0,H).
lst1(0,[{push,X}|H]) -> [X|lst1(0,H)];
lst1(K,[{push,X}|H]) -> lst1(K-1,H);
lst1(K,     [pop|H]) -> lst1(K+1,H);
lst1(K,          []) -> [].

%%
% a:push2(4,a:pop2(a:push2(3,a:push2(2,a:push2(1,{0,[]})))))
% --> {3,[{push,4},pop,{push,3},{push,2},{push,1}]}

push2(X,{N,H}) -> {N+1,[{push,X}|H]}.
pop2({N,H}) -> {N-1,[pop|H]}.

ver2(0,{N,           H}) -> lst1(0,H);
ver2(K,{N,     [pop|H]}) -> ver2(K-1,{N+1,H});
ver2(K,{N,[{push,X}|H]}) -> ver2(K-1,{N-1,H}).

%%
% Same test

ver3(K,{N,H}) -> ver3(K,N,H).
ver3(0,N,H) -> lst3(0,N,H);
ver3(K,N,[pop|H]) -> ver3(K-1,N+1,H);
ver3(K,N,[{push,X}|H]) -> ver3(K-1,N-1,H).

lst3({N,H}) -> lst3(0,N,H).
lst3(K,0,           H) -> [];
lst3(0,N,[{push,X}|H]) -> [X|lst3(0,N-1,H)];
lst3(K,N,[{push,X}|H]) -> lst3(K-1,N-1,H);
lst3(K,N,     [pop|H]) -> lst3(K+1,N+1,H).

%%
% a:push4(4,a:pop4(a:push4(3,a:push4(2,a:push4(1,{0,[]})))))
% --> {3,{push,4,{pop,{push,3,{push,2,{push,1,[]}}}}}}

push4(X,{N,H}) -> {N+1,{push,X,H}}.
pop4({N,H}) -> {N-1,{pop,H}}.    

ver4(K,{N,H}) -> ver4(K,N,H).
ver4(0,N,H) -> lst4(0,N,H);
ver4(K,N,{pop,H}) -> ver4(K-1,N+1,H);
ver4(K,N,{push,X,H}) -> ver4(K-1,N-1,H).

lst4({N,H}) -> lst4(0,N,H).
lst4(K,0,         H) -> [];
lst4(0,N,{push,X,H}) -> [X|lst4(0,N-1,H)];
lst4(K,N,{push,X,H}) -> lst4(K-1,N-1,H);
lst4(K,N,   {pop,H}) -> lst4(K+1,N+1,H).

% H5=a:pop4(a:push4(4,a:push4(3,a:pop4(a:push4(2,a:push4(1,{0,[]}))))))
% a:chg(3,{push,5},H5)

chg(0,U,N,H,M) -> rep(U,H,M);
chg(K,U,N,{pop,H},M) -> {N_,H_}=chg(K-1,U,N+1,H,M), {N_,{pop,H_}};
chg(K,U,N,{push,X,H},M) when N > M -> {N_,H_}=chg(K-1,U,N-1,H,M),
                                      {N_,{push,X,H_}};
chg(K,U,N,{push,X,H},M) -> {N_,H_}=chg(K-1,U,N-1,H,N-1).

rep(pop,{pop,H},M) -> {0,{pop,H}};
rep({push,X},{push,U,H},M) -> {0,{push,X,H}};
rep({push,X},{pop,H},M) -> {2,{push,X,H}};
rep(pop,{push,Y,H},M) -> {-2,{pop,H}}.

chg(K,U,{N,H}) -> {D,H_}=chg(K,U,N,H,N), {N+D,H_}.
                  
    
    
    
