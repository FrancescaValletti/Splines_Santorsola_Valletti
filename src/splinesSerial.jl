function sel(n::Int64)
    return list -> list[n]
end

S1 = sel(1)
S2 = sel(2)
S3 = sel(3)

S1([1,2,3])



function larBernsteinBasis(u::Function, n::Int64)
    function map_fn(x::Array{Float64,1})
        bernstein(i, n, t::Float64) = binomial(n,i)*(1-t)^(n-i)*t^i
        return [bernstein(i, n, u(x)) for i in 0:n]
    end
    return map_fn
end



function larTensorProdSurface{F<:Function, T<:Real}(args::Array{F, 1}, 
                            controlpoints::Array{Array{Array{T, 1}, 1}, 1})
    ubasis , vbasis = args
    function map_fn(point::Array{Float64, 1})
        u, v = point
        U = ubasis([u])
        V = vbasis([v])
        target_dim = length(controlpoints[1][1])
        ret = zeros(Float64, target_dim)
        dim_u = length(U)
        dim_v = length(V)
        if (length(controlpoints)!= dim_u || length(controlpoints[1])!= dim_v)
            error("Invalid set of control points for those bases!") 
        end
        for i in 1:dim_u
            for j in 1:dim_v
                #for M in 1:target_dim
                    for M in 1:target_dim 
                        ret[M] += U[i]*V[j]*controlpoints[i][j][M]
                    end
                #end
            end
        end
        return ret
    end
    return map_fn
end



function larBilinearSurface(controlpoints)
   basis = larBernsteinBasis(sel(1), 1)
   return larTensorProdSurface([basis, basis], controlpoints)
end

 
function larBiquadraticSurface(controlpoints)
   basis1 = larBernsteinBasis(sel(1), 2)
   basis2 = larBernsteinBasis(sel(1), 2)
   return larTensorProdSurface([basis1,basis2], controlpoints)
end

function larBicubicSurface(controlpoints)
   basis1 = larBernsteinBasis(sel(1), 3)
   basis2 = larBernsteinBasis(sel(1), 3)
   return larTensorProdSurface([basis1, basis2], controlpoints)
end

function larBezier{T<:Real}(u::Function, controldata::Array{Array{T,1},1})
    n = length(controldata) - 1
    dim = length(controldata[1])
    function map_fn(point::Array{Float64, 1})
        t = u(point)
        out = zeros(Float64, dim)
        for i in 0:n
            weight = binomial(n,i)*(1-t)^(n-i)*t^i
            for k in 1:dim
                out[k] += weight*controldata[i+1][k]
            end
        end
        return out
     end
    return map_fn
end



function larBezierCurve(controlpoints)
   return larBezier(sel(1), controlpoints)
end




function larCoonsPatch{T<:Function}(args::Array{T, 1})
    su0_fn , su1_fn , s0v_fn , s1v_fn = args
    function map_fn(point)
        u, v = point
        su0 = su0_fn(point)
        su1 = su1_fn(point)
        s0v = s0v_fn(point)
        s1v = s1v_fn(point)
        ret = zeros(Float64, length(su0))  
        for k in 1:length(ret)
            ret[k] = ((1-u)*s0v[k] + u*s1v[k]+(1-v)*su0[k] + v*su1[k] + 
                     (1-u)*(1-v)*s0v[k] + (1-u)*v*s0v[k] + u*(1-v)*s1v[k] + u*v*s1v[k])
        end
        return ret
    end
    return map_fn
end




function bsplineBasis{T<:Real}(degree::Int64, knots::Array{T,1}, ncontrols::Int64)
    n = ncontrols - 1
    m = length(knots) - 1
    k = degree + 1
    tmin, tmax = knots[k-1], knots[n+1]       
    if length(knots)!=(n+k+1) 
        error("Invalid point/knots/degree for bspline!") 
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







function t_bspline{T<:Real, F<:Function}(u::Function, degree::Int64, knots::Array{T,1}, 
                                    points_fn::Array{F, 1})
   
    n = length(points_fn)-1
    m = length(knots)-1
    k = degree + 1
    tmin,tmax = knots[k-1], knots[n+1]
   
    # see http://www.na.iac.cnr.it/~bdv/cagd/spline/B-spline/bspline-curve.html
    if length(knots)!=(n+k+1) 
        error("Invalid point/knots/degree for bspline!") 
    end
    # de Boor coefficients
    function deBoor(i::Int64, k::Int64, t::Float64)
        # Ni1(t)
        if k == 1 
            if(t>=knots[i] && t<knots[i+1]) || (t==tmax && t>=knots[i] && t<=knots[i+1])
                # i use strict inclusion for the max value
                return 1
            else
                return 0
            end
        end
        # Nik(t)
        ret = 0
        
        num1, div1 = t-knots[i], knots[i+k-1]-knots[i]  
        if div1 != 0 
            ret+=(num1/div1) * deBoor(i,k-1,t)
            # elif num1!=0: ret+=deBoor(i,k-1,t)
        end
        
        num2, div2 = knots[i+k]-t, knots[i+k]-knots[i+1]
        if div2!=0  
            ret+=(num2/div2) * deBoor(i+1,k-1,t)
            # elif num2!=0: ret+=deBoor(i,k-1,t)
        end
           
        return ret
    end
    
    # map function
    function map_fn(point::Array{Float64, 1})
        t = u(point)
        # if control points are functions
        #points = point -> [f(point) for f in points_fn]    #POSSIBILE ERRORE QUI
        target_dim = length(points_fn[1](point))    #errore qui
        ret = zeros(Float64, target_dim)
        for i in 1:n+1
            coeff = deBoor(i,k,t) 
            for m in 1:target_dim
                ret[m] += points_fn[i](point)[m] * coeff
            end
        end
        return ret
    end
    return map_fn
end




function t_nurbs{T<:Real, F<:Function}(u::Function, degree::Int64, knots::Array{T,1}, 
                                       points::Array{F, 1})
    bspline = t_bspline(u, degree, knots, points)
    function map_fn(point)          #eliminare
        ret = bspline(point)
        last = ret[end]  #last element in ret
        if last != 0
            ret = [value/last for value in ret]
        end
        ret = ret[1:end-1] #it slices off the last element (that is now 1)
        return ret
    end
    return map_fn
end
