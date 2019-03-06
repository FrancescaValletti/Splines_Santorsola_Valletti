include("splinesSerial.jl")
controlpoints = [[[0,0,0],[2,-4,2],[3,1,-1]],
		[[0,3,1],[4,0,0],[4,2,-4]],
		[[2,0,3],[0,5,1],[1,0,-4]],
		[[3,0,2],[-1,-1,-1],[2,3,0]],
		[[2,-1,0],[0,-4,1],[3,3,-3]]]

controlpointsp = [[[0,0,0],[2,-4,2],[3,1,-1],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[0,3,1],[4,0,0],[4,2,-4],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[2,0,3],[0,5,1],[1,0,-4],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[3,0,2],[-1,-1,-1],[2,3,0],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[2,-1,0],[0,-4,1],[3,3,-3],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]],
[[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))],[rand(Int64.(-5:5)),rand(Int64.(-5:5)),rand(Int64.(-5:5))]]]
basis1 = larBernsteinBasis(S1, 18)
basis2 = larBernsteinBasis(S1, 4)
point = [0.5, 0.2]
tensorprodsurf = larTensorProdSurface([basis1, basis2], controlpointsp)
result = tensorprodsurf(point)

