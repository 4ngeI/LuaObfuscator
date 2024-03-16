local parser = require("parser")
local helper = require("Utils.helper")

return function (code)
    local Strings = {}
    local TOKENS = parser.tokenize(code)
    local AST;
    do
        AST = parser.parse(TOKENS)
        parser.traverseTree(AST,function(node)
            if node.type == "call" then
                if not node.method then
                    if node.callee.type == "lookup" and node.callee.member and node.callee.value then
                        if type(node.callee.member.value) ~= "number" then
                            node.callee.member = parser.newNode("identifier",node.callee.member.value.."_var")
                        end
                    end
                else
                    node.callee.mod = true;
                end
            elseif node.type == "lookup" then
                if node.member.value ~= nil and type(node.member.value) ~= "number" and not node.mod then
                    local CANINSERT = true 
                    local NEW_INDEX = nil
                    for a,b in pairs(Strings) do
                        if b.value == node.member.value then
                            CANINSERT = false
                            break
                        end
                    end
                    if CANINSERT then
                        NEW_INDEX = helper.GEN_NUM()
                        table.insert(Strings,{index = NEW_INDEX,value = node.member.value})
                    else
                        NEW_INDEX = (function ()
                            for i,v in pairs(Strings) do
                                if v.value == node.member.value then
                                    return v.index
                                end
                            end
                            return 0
                        end)()
                    end
                    local NewNode = parser.parse("table[STRINGS_TABLE["..NEW_INDEX.."] ]()")
                    node.member = NewNode.statements[1].callee.member
                end
            end
        end)

        TOKENS = parser.tokenize(parser.toLua(AST))
        for i,v in pairs(TOKENS) do
            if v.type == "string" then
                local CANINSERT = true 
                for a,b in pairs(Strings) do
                    if b.value == v.value then
                        CANINSERT = false
                        break
                    end
                end
                if CANINSERT then
                    table.insert(Strings,{index = helper.GEN_NUM(),value = v.value})
                end
            end
        end
        for i,v in pairs(TOKENS) do
            if v.type == "string" then
                for a,b in pairs(Strings) do
                    if v.value == b.value then
                        v.value = "STRINGS_TABLE["..b.index.."]"
                        v.type = "identifier"
                    end
                end
            end
        end

        AST = parser.parse(TOKENS)
        code = parser.toLua(AST)
    end
    return code,Strings
end