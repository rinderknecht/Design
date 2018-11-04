-module(mean).
-compile(export_all).

floor(X) when X < trunc(X)   -> trunc(X) - 1;
floor(X)                     -> trunc(X).

ceiling(X) when X > trunc(X) -> trunc(X) + 1;
ceiling(X)                   -> trunc(X).
     
log2(X) -> math:log(X)/math:log(2).
exp2(0) -> 1;
exp2(N) -> E=exp2(N div 2), (1 + N rem 2)*(E*E).

mrg(M,N) -> M + N - M/(N+1) - N/(M+1).
bms0(N) -> bms(N) + N + ceiling(N/2) + 2*ceiling(log2(N)) - 1.
    
bms(0) -> 0;
bms(1) -> 0;
bms(N) -> E=exp2(ceiling(log2(N))-1),
          bms(E) + bms(N-E) + mrg(E,N-E).

tms(0) -> 0;
tms(1) -> 0;
tms(N) -> F=floor(N/2), C=ceiling(N/2),
          tms(F) + tms(C) + mrg(C,F).

h(0) -> 0;
h(N) -> 1/N + h(N-1).

i2wb(N) -> P = N div 2,
           case N rem 2 of
             0 -> P*P/2 + 13*P/4 + h(P)/8 - h(N)/4 + 2;
             1 -> P*P/2 + 15*P/4 + h(P)/8 - h(N)/4 + 13/4
           end.
