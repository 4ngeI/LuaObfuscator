local CODE_IN = io.open("files/in.lua", "rb"):read("*a")
local LOGGER = require("Utils.logger")

function Obfuscate(code)
    local strings_table = nil;
    local functions_table = nil

    local steps = {
        strings = require("Steps.strings"),
        WrapIn = require("Steps.WrapIn"),
        IsValid = require("Steps.IsValid"),
        Minifier = require("Steps.Minifier"),
        Functions = require("Steps.functions"),
        Booleans = require("Steps.booleans"),
        Conditions = require("Steps.conditions"),
        EQ_Checks = require("Steps.EQ_CHECK"),
    }
    local startTime = os.clock()
    local NewCode, Valid = steps.IsValid(code)
    if not Valid then
        LOGGER.ERROR("Invalid code detected.")
        return
    end
    code = NewCode
    
    code, functions_table = steps.Functions(code)
    code, strings_table = steps.strings(code)
    code = steps.Conditions(code)
    code = steps.Booleans(code)
    code = steps.EQ_Checks(code)
    
    code = steps.WrapIn(code, strings_table, functions_table)
    
    code = steps.Minifier(code)

    LOGGER.SUCCESS("Code obfuscation completed successfully.")
    LOGGER.logTimeTaken(startTime, "Code Obfuscation")
    
    return code
end

local startTime = os.clock()
local OBFUSCATED_CODE = Obfuscate(CODE_IN)
if OBFUSCATED_CODE then
    local file = io.open("files/out.lua", "w")
    if file then
        file:write(OBFUSCATED_CODE)
        file:close()
        LOGGER.SUCCESS("Obfuscated code written to file.")
    else
        LOGGER.ERROR("Failed to write obfuscated code to file.")
    end
end

LOGGER.logTimeTaken(startTime, "Entire Process")
