local component = require("component")
local serial = require("serialization")

component.modem.open(101);

function listener(eventID, a,b,c,d,e,f)
    if (eventID) then
        print(eventID)
        print(a)
        print(b)
        print(c)
        print(d)
        print(e)
    end
end

evetn.listen("modem_message",listener)

for i=1,15 do
    wait(1)
end