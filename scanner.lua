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

function scannPredict(count)
  

  local prdictTable = {}

  for i=-32,32 do
    prdictTable[i]={}
  end

  for i=-32,32 do
    os.execute("postep "..(i+32).." 64")
    for j=-32,-32 do
      prdictTable[i][j]=component.geolyzer.scan(i,j)
      for c=1,count do
        prdictTable[i][j]=add(prdictTable[i][j],component.geolyzer.scan(i,j))
      end
      prdictTable[i][j]=div(prdictTable[i][j],count)
    end
  end

end

function scannOres(predictTable)
  local foundsTable = {}

  for x=-32,32 do
    foundsTable[x]={}
    for y=-32,32 do
      foundsTable[x][y]={}
      for z=1,64 do
        if predictTable[x][y][z] > 2.5 then
          foundsTable[x][y][z-32] = true
        end
      end
    end
  end

  return foundsTable
end

local file = io.open(args[1],"w")
local foundsTable = scannOres(scannPredict(args[2]))
file:write(serial.serialize(foundsTable))
file:close()