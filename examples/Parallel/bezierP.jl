include("splinesParallel.jl")

controldata = [[0,1],[0,0],[1,1],[1,0],[0.1,0.1],[0.2,0.2],[0.3,0.3],[0.41,0.4],[0.89,0.73],[0.5,0.5],[0.6,0.6],[0.7,0.7],[0.8,0.8],[0.9,0.9]]

point = [0.5, 0.7, 1.2]
u = S2
plarBezier(u, controldata)(point)


