include("splinesParallel.jl")

Su0p = plarBezier(S1, [[0,0,0],[10,0,0]])
Su1p = plarBezier(S1, [[0,10,0],[2.5,10,3],[5,10,-3],[7.5,10,3],[10,10,0]])
Sv0p = plarBezier(S2, [[0,0,0],[0,0,3],[0,10,3],[0,10,0]])
Sv1p = plarBezier(S2, [[10,0,0],[10,5,3],[10,10,0]])


coons = plarCoonsPatch([Su0p,Su1p,Sv0p,Sv1p])
point = [0.2, 0.7]
coons(point)
