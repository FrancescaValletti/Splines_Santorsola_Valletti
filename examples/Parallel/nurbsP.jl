include("splinesParallel.jl")
include("splinesSerial.jl")

knots = [0,0,0,1,1,2,2,3,3,4,4,4]
p = sqrt(2)/2.0
controls = [[-1,0,1], [-p,p,p], [0,1,1], [p,p,p],[1,0,1], [p,-p,p], 
         [0,-1,1], [-p,-p,p], [-1,0,1]]
pc1 = plarBezier(S1, [[-1,0,0,1],[-1,0,1,1]])
pc2 = plarBezier(S1, [[-p,p,0,p],[-p,p,p,p]])
pc3 = plarBezier(S1, [[0,1,0,1],[0,1,1,1]])
pc4 = plarBezier(S1, [[p,p,0,p],[p,p,p,p]])
pc5 = plarBezier(S1, [[1,0,0,1],[1,0,1,1]])
pc6 = plarBezier(S1, [[p,-p,0,p],[p,-p,p,p]])
pc7 = plarBezier(S1, [[0,-1,0,1],[0,-1,1,1]])
pc8 = plarBezier(S1, [[-p,-p,0,p],[-p,-p,p,p]])
pc9 = plarBezier(S1, [[-1,0,0,1],[-1,0,1,1]])
controls = [pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9]
         
ptnurbs = pt_nurbs(S2,2,knots,controls)
point = [0.7, 0.2]
result = ptnurbs(point)

