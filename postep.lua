local shell = require("shell")
local args,ops = shell.parse(...)
local term = require("term")
local gpu = require("component").gpu

local step = args[1]
local all = args[2]

local count = 20

local proc = step/all*count

local x,y = term.getCursor()

local znak =  gpu.get(1,y-1)

if znak == ">" or znak == "=" then
  y=y-1
end

term.setCursor(1,y)
print(string.rep("=",proc-1)..">"..string.rep("-",count-proc))