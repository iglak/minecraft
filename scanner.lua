local shell = require("shell")
local args,ops = shell.parse(...)
local component = require("component")
local serial = require("serialization")

function add(a, b)
  local c = {}

  if #a==#b then
    for i,v in pairs(a) do
      c[i]=a[i]+b[i]
    end
  end

  return c
end

function div(a , d)
  for i,v in pairs(a) do
    a[i]=a[i]/d
  end
  
  return a
end

function quarters(quarter)
  local quarters = {} 

  if quarter == 1 then
    quarters.pi,quarters.ki = 0,32
    quarters.pj,quarters.kj = 0,32
  else if quarter == 2 then
    quarters.pi,quarters.ki = -32,-1
    quarters.pj,quarters.kj = 0,32
  else if quarter == 3 then
    quarters.pi,quarters.ki = -32,-1
    quarters.pj,quarters.kj = -32,-1
  else if quarter == 4 then
    quarters.pi,quarters.ki = 0,32
    quarters.pj,quarters.kj = -32,-1
  end
  end
  end
  end

  return quarters
end

function scannPredict(count, quart)

  local predictTable = {}
  
  for i=quart.pi,quart.ki do
    predictTable[i]={}
    os.execute("postep "..(i-quart.pi).." 32")
    for j=quart.pj,quart.kj do
      predictTable[i][j]=component.geolyzer.scan(i,j)
      for c=1,count do
        predictTable[i][j]=add(predictTable[i][j],component.geolyzer.scan(i,j))
      end
      predictTable[i][j]=div(predictTable[i][j],count+1)
    end
  end

  return predictTable
end

function scannOres(predictTable, quart)
  local foundsTable = {}
  local i = 1

  for x=quart.pi,quart.ki do
    for y=quart.pj,quart.kj do
      for z=1,64 do
        if predictTable[x][y][z] > 2.5 then
          foundsTable[i]={}
          foundsTable[i].x = x
          foundsTable[i].y = y
          foundsTable[i].z = z-32
          foundsTable[i].hardness = predictTable[x][y][z]
          i=i+1
        end
      end
    end
  end

  return foundsTable
end


local quart = quarters(1)

local file = io.open(args[1],"w")
local foundsTable = scannOres(scannPredict(args[2],quart),quart)
file:write(serial.serialize(foundsTable))
file:close()