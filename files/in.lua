local tbl = {}
tbl.__index = tbl
local a = string 
local b = a.byte 
local c = b((type({})),1,-1)
function tbl.new(name)
    local new = {}
    new.name = name
    return setmetatable(new,tbl)
end
function  tbl:print()
    print(self.name)
end

local a = tbl.new("RealName!1111")
a:print()
if c == 116 then
    print(c)
    print("YE")
end
