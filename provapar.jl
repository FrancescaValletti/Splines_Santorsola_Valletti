include("splinesParallel.jl")

 Su0 = @spawn larBezier(sel(1), [[0,0,0],[10,0,0]])
 Su1 = @spawn larBezier(sel(1), [[0,10,0],[2.5,10,3],[5,10,-3],[7.5,10,3],[10,10,0]])
 Sv0 = @spawn larBezier(sel(2), [[0,0,0],[0,0,3],[0,10,3],[0,10,0]])
 Sv1 = @spawn larBezier(sel(2), [[10,0,0],[10,5,3],[10,10,0]])


#point = [0.7, 0.2]
#out = larCoonsPatch([Su0,Su1,Sv0,Sv1])(point)
