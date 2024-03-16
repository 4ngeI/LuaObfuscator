local Logger={}
local R="\27[38;5;160m"
local Y="\27[38;5;214m"
local G="\27[38;5;46m"
local P="\27[38;5;93m"
local V="\27[38;5;129m"
local DEFAULT="\27[0m"

function Logger.ERROR(message)
    print(R.."[ERROR] "..message..DEFAULT)
end
function Logger.WARNING(message)
    print(Y.."[WARNING] "..message..DEFAULT)
end
function Logger.SUCCESS(message)
    print(G.."[SUCCESS] "..message..DEFAULT)
end
function Logger.logTimeTaken(startTime,TEXT)
    local endTime=os.clock()
    local timeTaken=endTime-startTime
    print("[TIME] "..V..TEXT.." took "..P..string.format(" %.4f seconds.",timeTaken)..DEFAULT)
end
return Logger