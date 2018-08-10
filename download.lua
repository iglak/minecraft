local shell = require("shell")
local args, ops = shell.parse(...)

oc.execute("rm "..args[1])
os.execute("wget https://raw.githubusercontent.com/iglak/minecraft/master/"..args[1])