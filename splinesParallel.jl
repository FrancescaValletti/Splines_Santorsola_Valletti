@everywhere function sel(n::Int64)
    return list -> list[n]
end



@everywhere function larBernsteinBasis(u::Function, n::Int64)
    bernstein(t::Float64, i::Int64) = binomial(n,i)*((1-t)^(n-i))*t^i
    map_fn = x::Array{Float64,1} -> [bernstein(u(x),i) for i in 0:n]
    return map_fn
end



@everywhere function larTensorProdSurface{Y<:Function, T<:Real}(args::Array{Y, 1}, 
                            controlpoints::Array{Array{Array{T, 1}, 1}, 1})
    ubasis , vbasis = args
    function map_fn(point::Array{Float64, 1})
        x, y = point
        u = ubasis([x])
        v = vbasis([y])
        target_dim = length(controlpoints[1][1])
        ret = zeros(Float64, target_dim)
        dim_u = length(u)
        dim_v = length(v)
        try
            length(controlpoints[1])!= dim_u
            length(controlpoints[2])!= dim_v
        catch e
            println("Invalid set of control points for those bases")
        end
        for i in 1:dim_u
            for j in 1:dim_v
                for m in 1:target_dim
                    for m in 1:target_dim 
                        ret[m] += u[i]*v[j]*controlpoints[i][j][m]
                    end
                end
            end
        end
        return ret
    end
    return map_fn
end



@everywhere function larBilinearSurface(controlpoints)
   basis = larBernsteinBasis(sel(1), 1)
   return larTensorProdSurface([basis, basis], controlpoints)
end

 
@everywhere function larBiquadraticSurface(controlpoints)
   basis1 = larBernsteinBasis(sel(1), 2)
   basis2 = larBernsteinBasis(sel(1), 2)
   return larTensorProdSurface([basis1,basis2], controlpoints)
end

@everywhere function larBicubicSurface(controlpoints)
   basis1 = larBernsteinBasis(sel(1), 3)
   basis2 = larBernsteinBasis(sel(1), 3)
   return larTensorProdSurface([basis1, basis2], controlpoints)
end

@everywhere function larBezier{T<:Real}(u::Function, controldata::SharedArray{SharedArray{T,1},1})
    controldata  = (hcat(controldata...))'    # controldata is now a matrix
    n = size(controldata, 1) - 1
    dim = size(controldata, 2)
    weight_fn = i::Int64 -> (t::Float64 -> binomial(n,i)*((1-t)^(n-i))*(t^i))
    v_weight = t::Float64 -> [weight_fn(i)(t) for i in 0:n]
    out_k = (t::Float64, k::Int64) -> sum(controldata[:, k].*v_weight(t))
    map_fn = x::SharedArray{Float64,1} -> [out_k(u(x), k) for k in 1:dim]
    return map_fn
end

@everywhere function larBezierCurve(controlpoints)
   return larBezier(sel(1), controlpoints)
end




@everywhere function bsplineBasis{T<:Real}(degree::Int64, knots::Array{T,1}, ncontrols::Int64)
    n = ncontrols - 1
    m = length(knots) - 1
    k = degree + 1
    tmin, tmax = knots[k-1], knots[n+1]       
    try
        length(knots) != (n+k+1)
    catch e
        println("Invalid point/knots/degree for bspline!")
    end
    # de Boor coefficients
    function deBoor(i::Int64, k::Int64, t::Float64)           
        # deBoor coefficient Ni1(t)
        if k == 1
            if(t >= knots[i] && t<knots[i+1]) || (t == tmax && t>=knots[i] && t<=knots[i+1])
                # t in [T_i, T_(i+1)) vel t=T_(n+1) in [T_i, T_(i+1)]
                return 1
            else
                return 0
            end
        end
        # deBoor coefficient Nik(t)
        ret = 0    
        num1, div1 = t-knots[i], knots[i+k-1]-knots[i]
        if div1 != 0 
            ret += (num1/div1) * deBoor(i,k-1,t) 
        end
        num2, div2 = knots[i+k]-t, knots[i+k]-knots[i+1]
        if div2 != 0
            ret += (num2/div2) * deBoor(i+1,k-1,t)
        end
        return ret
    end
    # map function
    function map_fn{T<:Real}(point::Array{T, 1})
        t = point[1]
        return [deBoor(i,k,t) for i in 1:n+1]
    end
    return map_fn
end





@everywhere function larCoonsPatch{F<:Function}(args::Array{F,1})
    		su0_fn , su1_fn , s0v_fn , s1v_fn = args
    		#u, v = point
    		su0 = point::Array{Float64,1} -> typeof(su0_fn)<:Function? su0_fn(point) : su0_fn
    		su1 = point::Array{Float64,1} -> typeof(su1_fn)<:Function? su1_fn(point) : su1_f
		s0v = point::Array{Float64,1} -> typeof(s0v_fn)<:Function? s0v_fn(point) : s0v_fn
		s1v = point::Array{Float64,1} -> typeof(s1v_fn)<:Function? s1v_fn(point) : s1v_fn
		dim = size(su0_fn([0.0, 0.0, 0.0]), 1)    #vector function's length
		map_fn(u::Float64, v::Float64, k::Int64) = ((1-u)*s0v([u,v])[k] + u*s1v([u,v])[k]+(1-v)*su0([u,v])[k] + v*su1([u,v])[k] + 
		   (1-u)*(1-v)*s0v([u,v])[k] + (1-u)*v*s0v([u,v])[k] + u*(1-v)*s1v([u,v])[k] + u*v*s1v([u,v])[k])
	return point -> [map_fn(sel(1)(point), sel(2)(point), k) for k in 1:dim]
end
