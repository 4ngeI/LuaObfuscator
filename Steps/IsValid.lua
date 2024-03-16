local parser = require("parser")
return function (code)
    if code == "" then return nil,false end
    local tkns = parser.tokenize(code)
    local AST = parser.parse(code)
    local suc,err = pcall(function ()
        parser.validateTree(AST)
    end)
    if suc then
        return parser.toLua(AST),true
    end
    return nil,false
end