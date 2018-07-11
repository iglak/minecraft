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

  local prdictTable = {}
  
  for i=quart.pi,quart.ki do
    prdictTable[i]={}
    os.execute("postep "..(i-quart.pi).." 32")
    for j=quart.pj,quart.kj do
      prdictTable[i][j]=component.geolyzer.scan(i,j)
      for c=1,count do
        prdictTable[i][j]=add(prdictTable[i][j],component.geolyzer.scan(i,j))
      end
      prdictTable[i][j]=div(prdictTable[i][j],count)
    end
  end

end

function scannOres(predictTable, quart)
  local foundsTable = {}

  for x=quart.pi,quart.ki do
    foundsTable[x]={}
    for y=quart.pj,quart.kj do
      foundsTable[x][y]={}
      for z=1,64 do
        print("Debug Scann z,y,z",z,y,z)
        print("Debug 1,1,1", predictTable[1][1][1])
        if predictTable[x][y][z] > 2.5 then
          foundsTable[x][y][z-32] = true
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