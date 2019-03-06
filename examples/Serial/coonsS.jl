include("splinesSerial.jl")

Su0 = larBezier(S1, [[0,0,0],[10,0,0]])
Su1 = larBezier(S1, [[0,10,0],[2.5,10,3],[5,10,-3],[7.5,10,3],[10,10,0]])
Sv0 = larBezier(S2, [[0,0,0],[0,0,3],[0,10,3],[0,10,0]])
Sv1 = larBezier(S2, [[10,0,0],[10,5,3],[10,10,0]])
coons = larCoonsPatch([Su0,Su1,Sv0,Sv1])
point = [0.2, 0.7]
coons(point)


