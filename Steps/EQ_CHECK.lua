local parser = require("parser");

local function eq(code) --==
    local ast = parser.parse(code);
    parser.traverseTree(ast,function (node,_,container,key)
        if node.type == "binary" and node.operator == "==" then
            if node.right.type ~= "binary" then
                container[key] = parser.parse("check_eq("..parser.toLua(node):gsub(node.operator,",")..")").statements[1]
            end
        end
    end)
    return parser.toLua(ast)
end
local function lt(code) --<
    local ast = parser.parse(code);
    parser.traverseTree(ast,function (node,_,container,key)
        if node.type == "binary" and node.operator == "<" then
            if node.right.type ~= "binary" then
                container[key] = parser.parse("check_lt("..parser.toLua(node):gsub(node.operator,",")..")").statements[1]
            end
        end
    end)
    return parser.toLua(ast)
end

return function (code)
    code = eq(code);
    code = lt(code)
    return code
end