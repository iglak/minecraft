local shell = require("shell")
local args,ops = shell.parse(...)
local component = require("component")
local serial = require("serialization")
local computer = require("computer")

local startTime = computer.uptime()

local foundsTable = {}
local fi = 1

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

function scannPredict(quart)

  local predictTable = {}
  
  for i=quart.pi,quart.ki do
    predictTable[i]={}
    os.execute("postep "..(i-quart.pi).." 32")
    for j=quart.pj,quart.kj do
      predictTable[i][j]=component.geolyzer.scan(i,j)
      local count = math.floor((math.abs(i)+math.abs(j))/2)
      for c=0,count do
        predictTable[i][j]=add(predictTable[i][j],component.geolyzer.scan(i,j))
      end
      predictTable[i][j]=div(predictTable[i][j],count+2)
    end
  end

  return predictTable
end

function scannOres(predictTable, quart)
  

  for x=quart.pi,quart.ki do
    for y=quart.pj,quart.kj do
      for z=1,64 do
        if predictTable[x][y][z] > 2.5 then
          foundsTable[fi]={}
          foundsTable[fi].x = x
          foundsTable[fi].y = y
          foundsTable[fi].z = z-32
          foundsTable[fi].hardness = predictTable[x][y][z]
          fi=fi+1
        end
      end
    end
  end

  return foundsTable
end



local quart = quarters(1)
scannOres(scannPredict(quart),quart)
print(1)
quart = quarters(2)
scannOres(scannPredict(quart),quart)
print(2)
quart = quarters(3)
scannOres(scannPredict(quart),quart)
print(3)
quart = quarters(4)
scannOres(scannPredict(quart),quart)

local file = io.open(args[1],"w")
file:write(serial.serialize(foundsTable))
file:close()

print(computer.uptime()-startTime) 