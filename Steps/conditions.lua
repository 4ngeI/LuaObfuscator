-- IF STATEMENTS 
local parser = require("parser")

local function NewCondition(AstNode)
    local DefaultCondition = parser.toLua(AstNode.condition)
    local NEW_CONDITIONS = {
        ("true ~= 0 and %s"):format(DefaultCondition),
        ("ConditionChecker <= ConditionChecker*2 and %s"):format(DefaultCondition),
    }
    local NEW = string.format("if (%s) then end",NEW_CONDITIONS[math.random(#NEW_CONDITIONS)])
    local NEWNODE = parser.parse(NEW)
    return NEWNODE.statements[1].condition
end

return function (code)
    local AST = parser.parse(code)

    parser.traverseTree(AST,function (node)
        if node.type == "if" then
            node.condition = NewCondition(node)
        end
    end)

    return parser.toLua(AST)
end