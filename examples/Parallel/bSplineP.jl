include("splinesParallel.jl")

knots = [0,0,0,0,1,2,3,4,4,4,4]
ncontrols = 8
degree = 2
basis = pbsplineBasis(degree, knots, ncontrols)
point = [0.7,0.2,3.0]
basis(point)


