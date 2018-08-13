local component = require("component")
local serial = require("serialization")
local event = require("event")

local table = {}
local counter = 0 

component.modem.open(101);
event.listen("modem_message",listener)

function listener(eventID, _,_,_,_,content)
    if (eventID) then
        table[counter] = serial.unserialize(content)
        counter=counter+1
    end
end







