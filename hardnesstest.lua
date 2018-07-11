local geo = require("component").geolyzer
local shell = require("shell")

local args,opt = shell.parse(...)

local table = {}
local out = {}
local x =tonumber(args[1])
local y= tonumber(args[2])
local count = tonumber(args[3])
table=geo.scan(x,y)
for i,v in ipairs(table) do
  if v~=0 then 
    out[i-32]=0
  end
end

for j=1,count do 
  table=geo.scan(x,y)
  for i,v in ipairs(table) do
    if v~=0 then    
      out[i-32]=v+out[i-32]
    end
  end
end  

for i,v in pairs(out) do
  v=v/count
  print(i,v)
end