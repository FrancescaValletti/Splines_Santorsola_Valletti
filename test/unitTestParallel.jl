using Base.Test
include("splinesParallel.jl") 

@testset "splines" begin
	point = [0.5, 0.7, 1.2]
	V = [1.0,3.4,5.5,6.9,2.4,8.0];
	FV = [[1,2,4],[2,3,5],[3,5,6],[4,5,7],[5,7,8],[6,8,9]];
	@testset "sel" begin
 		@test typeof(sel(1)(V))==Float64
		@test typeof(sel(1)(FV))==Array{Int64,1}
		@test sel(4)(V)==6.9
		@test sel(5)(FV)==[5,7,8]
	end
	@testset "larBernsteinBasis" begin
		@test typeof(larBernsteinBasis(sel(1),3)([0.5,2,7.3]))==Array{Float64,1}
		@test typeof(larBernsteinBasis(sel(5), 6)(V))==
		Array{Float64,1}
		H=[1.2,3.4,5.6,7.8,9.0]
		F=larBernsteinBasis(sel(4),5)(H)
		@test length(F)==6
	end

	@testset "plarTensorProdSurface" begin
		controlpoints = [[[0,0,0],[2,-4,2]],[[0,3,1],[4,0,0]]]
		basis = larBernsteinBasis(sel(1), 1)
		point = [0.5, 2, 7.3]
		T=plarTensorProdSurface([basis, basis], controlpoints)(point)
		@test typeof(T)==SharedArray{Float64,1}
		@test length(T)==3
	end

	@testset "plarBilinearSurface" begin
		controlpoints = [[[0,0,0],[2,-4,2]],[[0,3,1],[4,0,0]]]
		Bil=plarBilinearSurface(controlpoints)([0.5,0.7])
		@test typeof(Bil)==SharedArray{Float64,1}
		@test length(Bil)==3
	end

	@testset "plarBiquadraticSurface" begin
		controlpoints = [[[0,0,0],[2,0,1],[3,1,1]],[[1,3,-1],[2,2,0],[3,2,0]],[[-2,4,0],[2,5,1],[1,3,2]]]
		mapping = plarBiquadraticSurface(controlpoints)([0.7, 0.2])
		@test typeof(mapping)==SharedArray{Float64,1}
		@test length(mapping)==3
	end

	@testset "plarBicubicSurface" begin
		controlpoints = [[[0,0,0], [0,3,4], [0,6,3], [0,10,0]],[[3,0,2], [2,2.5,5], [3,6,5], [4,8,2]],[[6,0,2], [8,3,5], [7,6,4.5], [6,10,2.5]],[[10,0,0], [11,3,4], [11,6,3], [10,9,0]]]
		mapping = plarBicubicSurface(controlpoints)([0.7,0.2])
		@test typeof(mapping)==SharedArray{Float64,1}
		@test length(mapping)==3	
	end

	@testset "plarBezier"begin
		controldata = [[0,1],[0,0],[1,1],[1,0]]
		U = sel(2)
		@test typeof(plarBezier(U, controldata)(point))==
		SharedArray{Float64,1}
		G=plarBezier(U, controldata)(point)
		@test length(G)==2
		@test typeof(plarBezier(sel(3), controldata)(point))==
		SharedArray{Float64,1}
		F=plarBezier(sel(3), controldata)(point)
		@test length(F)==2
	end

	@testset "plarBezierCurve" begin
		controldata = [[1,2,-5],[2,-4,2]]
		@test typeof(plarBezierCurve(controldata)(point))==SharedArray{Float64,1}
		@test length(plarBezierCurve(controldata)(point))==3		
	end

	@testset "bsplineBasis" begin
		knots = [0,0,0,1,1,2,2,3,3,4,4,4]
		ncontrols = 9
		degree = 2
		H=bsplineBasis(degree, knots, ncontrols)([0.7,2.5,3.0])
		@test typeof(bsplineBasis(degree, knots, ncontrols)([0.7,2.5,3.0]))==Array{Float64,1}
		@test length(bsplineBasis(degree, knots, ncontrols)([0.7,2.5,3.0]))==9	
	end
	
	
	@testset "plarCoonsPatch" begin
		Su0 = plarBezier(sel(1), [[0,0,0],[10,0,0]])
		Su1 = plarBezier(sel(1), [[0,10,0],[2.5,10,3],[5,10,-3],[7.5,10,3],[10,10,0]])
		Sv0 = plarBezier(sel(1), [[0,0,0],[0,0,3],[0,10,3],[0,10,0]])
		Sv1 = plarBezier(sel(2), [[10,0,0],[10,5,3],[10,10,0]])
		point = [0.7, 0.2]
		out = plarCoonsPatch([Su0,Su1,Sv0,Sv1])(point)
		@test typeof(out)==Array{Float64,1}
	end

	@testset "pt_bspline"begin
		b1 = plarBezier(S1, [[0,1,0],[0,1,5]])
		b2 = plarBezier(S1, [[0,0,0],[0,0,5]])
		b3 = plarBezier(S1, [[1,0,0],[2,-1,2.5],[1,0,5]])
		b4 = plarBezier(S1, [[1,1,0],[1,1,5]])
		b5 = plarBezier(S1, [[0,1,0],[0,1,5]])
		controls = [b1, b2, b3, b4, b5]
		knots = [0,1,2,3,4,5,6,7]           # periodic B-spline
		knots = [0,0,0,1,2,3,3,3]           # non-periodic B-spline
		ptbspline = pt_bspline(S2, 2, knots, controls) 
		B=ptbspline([0.7, 0.2])
		@test typeof(B)==SharedArray{Float64,1}
		@test length(B)==3
	end


	@testset "pt_nurbs" begin
		knots = [0,0,0,1,1,2,2,3,3,4,4,4]
		p=sqrt(2)/2.0
		controls = [[-1,0,1], [-p,p,p], [0,1,1], [p,p,p],[1,0,1], [p,-p,p],[0,-1,1], [-p,-p,p], [-1,0,1]]
		c1 = plarBezier(S1, [[-1,0,0,1],[-1,0,1,1]])
		c2 = plarBezier(S1, [[-p,p,0,p],[-p,p,p,p]])
		c3 = plarBezier(S1, [[0,1,0,1],[0,1,1,1]])
		c4 = plarBezier(S1, [[p,p,0,p],[p,p,p,p]])
		c5 = plarBezier(S1, [[1,0,0,1],[1,0,1,1]])
		c6 = plarBezier(S1, [[p,-p,0,p],[p,-p,p,p]])
		c7 = plarBezier(S1, [[0,-1,0,1],[0,-1,1,1]])
		c8 = plarBezier(S1, [[-p,-p,0,p],[-p,-p,p,p]])
		c9 = plarBezier(S1, [[-1,0,0,1],[-1,0,1,1]])
		controls = [c1,c2,c3,c4,c5,c6,c7,c8,c9]         
		tnurbs = pt_nurbs(S2,2,knots,controls)
		N=tnurbs([0.7, 0.2])
		@test typeof(N)==Array{Float64,1}
		@test length(N)==3
	end
	
end



