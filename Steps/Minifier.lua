local parser = require("parser")
local OPTIONS = require("Utils.Options")

return function (code)
    local AST = parser.parse(code)
    if OPTIONS.Variables then
        parser.minify(AST)
    end
    return parser.toLua(AST,OPTIONS.Beautify)
end