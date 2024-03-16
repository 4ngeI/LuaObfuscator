local parser = require("parser")
local helper = require("Utils.helper")

return function (code)
    local FUNCTIONS_TABLE = {}
    local AST = parser.parse(code)

    parser.traverseTree(AST,function (node)
        if node.type == "declaration" then
            for i,v in pairs(node.names) do
                if v.type == "identifier" and getfenv()[v.name] then
                    v.IsFunction = true
                end
            end
        elseif node.type == "identifier" then
            if not node.IsFunction then 
                if getfenv()[node.name] then
                    if not helper.TABLE_FIND(FUNCTIONS_TABLE,node.name) then
                        table.insert(FUNCTIONS_TABLE,node.name)
                    end
                    node.name = "FUNCTIONS_TABLE["..(function()
                        for i,v in pairs(FUNCTIONS_TABLE) do
                            if v == node.name then
                                return i
                            end
                        end
                        return "MISSING VALUE"
                    end)().."]"
                end
            end
        end
    end)

    return parser.toLua(AST),FUNCTIONS_TABLE
end