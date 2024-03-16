local parser = require("parser")
local function NewFalseBool()
    math.randomseed(os.time())
    local CONDITIONS = { 
        "ConditionChecker/213 > ConditionChecker and ConditionChecker <= 5",
        "ConditionChecker < ConditionChecker/231",
    }
    return CONDITIONS[math.random(#CONDITIONS)]
end
local function NewTrueBool()
    math.randomseed(os.time())
    local CONDITIONS = { 
        "ConditionChecker > ConditionChecker-1",
        "ConditionChecker/2 > ConditionChecker/(2*2)",
        "ConditionChecker-ConditionChecker/2 <= ConditionChecker"
    }    
    return CONDITIONS[math.random(#CONDITIONS)]
end
return function (code)
    local TOKENS = parser.tokenize(code)
    for i,v in pairs(TOKENS) do
        if v.type == "keyword" then
            if v.value == "true" then
                v.value = NewTrueBool()
                v.type = "identifier"
            elseif v.value == "false" then
                v.value = NewFalseBool()
                v.type = "identifier"
            end
        end
    end
    return parser.toLua(parser.parse(TOKENS))
end