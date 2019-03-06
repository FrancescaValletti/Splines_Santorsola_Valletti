include("splinesParallel.jl")

V=[0.1,0.2,0.3]

B1=fetch(@spawnat 2 larBernsteinBasis(sel(1),4)(V))
B2=fetch(@spawnat 3 larBernsteinBasis(sel(2),4)(V))
B3=fetch(@spawnat 4 larBernsteinBasis(sel(3),4)(V))

C=[B1,B2,B3]

