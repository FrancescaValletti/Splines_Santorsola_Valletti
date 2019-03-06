using Base.Test
include("splinesSerial.jl") 

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

	@testset "larTensorProdSurface" begin
		controlpoints = [[[0,0,0],[2,-4,2]],[[0,3,1],[4,0,0]]]
		basis = larBernsteinBasis(sel(1), 1)
		point = [0.5, 2, 7.3]
		T=larTensorProdSurface([basis, basis], controlpoints)(point)
		@test typeof(T)==Array{Float64,1}
		@test length(T)==3
	end

	@testset "larBilinearSurface" begin
		controlpoints = [[[0,0,0],[2,-4,2]],[[0,3,1],[4,0,0]]]
		Bil=larBilinearSurface(controlpoints)([0.5,0.7])
		@test typeof(Bil)==Array{Float64,1}
		@test length(Bil)==3
	end

	@testset "larBiquadraticSurface" begin
		controlpoints = [[[0,0,0],[2,0,1],[3,1,1]],[[1,3,-1],[2,2,0],[3,2,0]],[[-2,4,0],[2,5,1],[1,3,2]]]
		mapping = larBiquadraticSurface(controlpoints)([0.7, 0.2])
		@test typeof(mapping)==Array{Float64,1}
		@test length(mapping)==3
	end

	@testset "larBicubicSurface" begin
		controlpoints = [[[0,0,0], [0,3,4], [0,6,3], [0,10,0]],[[3,0,2], [2,2.5,5], [3,6,5], [4,8,2]],[[6,0,2], [8,3,5], [7,6,4.5], [6,10,2.5]],[[10,0,0], [11,3,4], [11,6,3], [10,9,0]]]
		mapping = larBicubicSurface(controlpoints)([0.7,0.2])
		@test typeof(mapping)==Array{Float64,1}
		@test length(mapping)==3	
	end

	@testset "larBezier"begin
		controldata = [[0,1],[0,0],[1,1],[1,0]]
		U = sel(2)
		@test typeof(larBezier(U, controldata)(point))==
		Array{Float64,1}
		G=larBezier(U, controldata)(point)
		@test length(G)==2
		@test typeof(larBezier(sel(3), controldata)(point))==
		Array{Float64,1}
		F=larBezier(sel(3), controldata)(point)
		@test length(F)==2
	end

	@testset "larBezierCurve" begin
		controldata = [[1,2,-5],[2,-4,2]]
		@test typeof(larBezierCurve(controldata)(point))==Array{Float64,1}
		@test length(larBezierCurve(controldata)(point))==3		
	end

	@testset "bsplineBasis" begin
		knots = [0,0,0,1,1,2,2,3,3,4,4,4]
		ncontrols = 9
		degree = 2
		H=bsplineBasis(degree, knots, ncontrols)([0.7,2.5,3.0])
		@test typeof(bsplineBasis(degree, knots, ncontrols)([0.7,2.5,3.0]))==Array{Float64,1}
		@test length(bsplineBasis(degree, knots, ncontrols)([0.7,2.5,3.0]))==9	
	end
	
	
	@testset "larCoonsPatch" begin
		Su0 = larBezier(sel(1), [[0,0,0],[10,0,0]])
		Su1 = larBezier(sel(1), [[0,10,0],[2.5,10,3],[5,10,-3],[7.5,10,3],[10,10,0]])
		Sv0 = larBezier(sel(1), [[0,0,0],[0,0,3],[0,10,3],[0,10,0]])
		Sv1 = larBezier(sel(2), [[10,0,0],[10,5,3],[10,10,0]])
		point = [0.7, 0.2]
		out = larCoonsPatch([Su0,Su1,Sv0,Sv1])(point)
		@test typeof(out)==Array{Float64,1}
	end

	@testset "t_bspline"begin
		b1 = larBezier(S1, [[0,1,0],[0,1,5]])
		b2 = larBezier(S1, [[0,0,0],[0,0,5]])
		b3 = larBezier(S1, [[1,0,0],[2,-1,2.5],[1,0,5]])
		b4 = larBezier(S1, [[1,1,0],[1,1,5]])
		b5 = larBezier(S1, [[0,1,0],[0,1,5]])
		controls = [b1, b2, b3, b4, b5]
		knots = [0,1,2,3,4,5,6,7]           # periodic B-spline
		knots = [0,0,0,1,2,3,3,3]           # non-periodic B-spline
		tbspline = t_bspline(S2, 2, knots, controls) 
		B=tbspline([0.7, 0.2])
		@test typeof(B)==Array{Float64,1}
		@test length(B)==3
	end


	@testset "t_nurbs" begin
		knots = [0,0,0,1,1,2,2,3,3,4,4,4]
		p=sqrt(2)/2.0
		controls = [[-1,0,1], [-p,p,p], [0,1,1], [p,p,p],[1,0,1], [p,-p,p],[0,-1,1], [-p,-p,p], [-1,0,1]]
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
		N=tnurbs([0.7, 0.2])
		@test typeof(N)==Array{Float64,1}
		@test length(N)==3
	end
	
end



