local HELPER = {}
local USED_NUMS = {}

function HELPER.TABLE_FIND(table,value)
    for i,v in pairs(table) do if v == value then return true end end 
    return false
end
function HELPER.GEN_NUM()
    math.randomseed(os.time())
    local NUM
    repeat
        NUM = math.random(10,400)
    until not HELPER.TABLE_FIND(USED_NUMS,NUM)
    table.insert(USED_NUMS,NUM)
    return NUM
end

return HELPER