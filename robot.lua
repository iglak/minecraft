local component = require("component")
local serial = require("serialization")
local event = require("event")

component.modem.open(101);

function listener(eventID, _,_,_,_,content)
    if (eventID) then
        print(eventID,content)
    end
end

event.listen("modem_message",listener)
