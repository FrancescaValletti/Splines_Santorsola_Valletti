include("splinesSerial.jl")

b1 = larBezier(S1, [[0,1,0],[0,1,5]])
b2 = larBezier(S1, [[0,0,0],[0,0,5]])
b3 = larBezier(S1, [[1,0,0],[2,-1,2.5],[1,0,5]])
b4 = larBezier(S1, [[1,1,0],[1,1,5]])
b5 = larBezier(S1, [[0,1,0],[0,1,5]])
controls = [b1, b2, b3, b4, b5]
knots = [0,1,2,3,4,5,6,7]           # periodic B-spline
knots = [0,0,0,1,2,3,3,3]           # non-periodic B-spline
tbspline = t_bspline(S2, 2, knots, controls) 
point = [0.7, 0.2]
result = tbspline(point)


