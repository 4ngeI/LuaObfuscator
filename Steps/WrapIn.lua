local strings = require("Steps.strings")

return function (code,STRINGS_TABLE,FUNCTIONS_TABLE)
    math.randomseed(os.time())
    local STRING_ARRAY = "" do
        for i,v in pairs(STRINGS_TABLE) do
            STRING_ARRAY = STRING_ARRAY..'['..v.index..']="'..v.value..'"'
            if i ~= #STRINGS_TABLE then
                STRING_ARRAY=STRING_ARRAY..","
            end
        end
    end
    local FUNCTIONS_ARRAY = "" do
        for i,v in pairs(FUNCTIONS_TABLE) do
            FUNCTIONS_ARRAY = FUNCTIONS_ARRAY..v
            if i ~= #FUNCTIONS_TABLE then
                FUNCTIONS_ARRAY=FUNCTIONS_ARRAY..","
            end
        end
    end

    local REM = ([[
        return(function(STRINGS_TABLE,FUNCTIONS_TABLE,check_eq,check_lt)
            local ConditionChecker = %s
            %s
        end)(
        {%s},
        {%s},
        (function(a,b)
            return a == b
        end),
        (function(a,b)
            return a < b
        end))
    ]]):format(math.random(2999),code,STRING_ARRAY,FUNCTIONS_ARRAY)
    return REM
end