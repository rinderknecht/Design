-module(max).
-compile(nowarn_export_all).
-compile(export_all).

ceiling(X) when X > trunc(X) -> trunc(X) + 1;
ceiling(X)                   -> trunc(X).

log2(X) -> math:log(X)/math:log(2).

exp2(0) -> 1;
exp2(N) -> E=exp2(N div 2), (1 + N rem 2)*(E*E).

rho(1) -> 0;
rho(N) -> case N rem 2 of
            0 -> rho(N div 2) + 1;
            1 -> 0
          end.

nu(0) -> 0;
nu(N) -> nu(N div 2) + N rem 2.

bms(0) -> 0;
bms(1) -> 0;
bms(N) -> K = N div 2,
          case N rem 2 of
            0 -> bms(N-1) + nu(K-1) + 1;
            1 -> bms(N-2) + 2*exp2(rho(K)) + nu(K-1) + nu(K)
          end.

tms(0) -> 0;
tms(1) -> 0;
tms(N) -> L = ceiling(log2(N)), N*L - exp2(L) + 1.
