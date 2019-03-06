include("splinesSerial.jl")

controlpoints=[
   [[ 0,0,0],[0 ,3  ,4],[0,6,3],[0,10,0]],
   [[ 3,0,2],[2 ,2.5,5],[3,6,5],[4,8,2]],
   [[ 6,0,2],[8 ,3 , 5],[7,6,4.5],[6,10,2.5]],
   [[10,0,0],[11,3  ,4],[11,6,3],[10,9,0]]]

bicubic = larBicubicSurface(controlpoints)
point = [0.7,0.2]
result = bicubic(point)
