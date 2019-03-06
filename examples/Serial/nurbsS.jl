include("splinesSerial.jl")

knots = [0,0,0,1,1,2,2,3,3,4,4,4]
p = sqrt(2)/2.0
controls = [[-1,0,1], [-p,p,p], [0,1,1], [p,p,p],[1,0,1], [p,-p,p], 
         [0,-1,1], [-p,-p,p], [-1,0,1]]
c1 = larBezier(S1, [[-1,0,0,1],[-1,0,1,1]])
c2 = larBezier(S1, [[-p,p,0,p],[-p,p,p,p]])
c3 = larBezier(S1, [[0,1,0,1],[0,1,1,1]])
c4 = larBezier(S1, [[p,p,0,p],[p,p,p,p]])
c5 = larBezier(S1, [[1,0,0,1],[1,0,1,1]])
c6 = larBezier(S1, [[p,-p,0,p],[p,-p,p,p]])
c7 = larBezier(S1, [[0,-1,0,1],[0,-1,1,1]])
c8 = larBezier(S1, [[-p,-p,0,p],[-p,-p,p,p]])
c9 = larBezier(S1, [[-1,0,0,1],[-1,0,1,1]])
controls = [c1,c2,c3,c4,c5,c6,c7,c8,c9]
         
tnurbs = t_nurbs(S2,2,knots,controls)
point = [0.7, 0.2]
result = tnurbs(point)
