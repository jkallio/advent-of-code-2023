local file = io.open("input", "r")
if not file then
    print("File not found")
    return
end

--- Trim leading and trailing whitespace from a string
--- @param self string
function string:trim()
    return self:gsub("^%s*(.-)%s*$", "%1")
end

--- Split string into table by delimiter
--- @param self string
function string:split(delim)
    local result = {}
    local pattern = "(.-)" .. delim .. "()"
    local lastPos
    for part, pos in self:gmatch(pattern) do
        part = part:trim()
        if part ~= "" then
            table.insert(result, tonumber(part))
        end
        lastPos = pos
    end
    if lastPos and lastPos <= #self then
        local lastPart = self:sub(lastPos)
        lastPart = lastPart:trim()
        if lastPart ~= "" then
            table.insert(result, tonumber(lastPart))
        end
    end
    return result
end

local numbers = {}
local winningNumbers = {}
local cardStack = {}
local lineCount = 0
for line in file:lines() do
    lineCount = lineCount + 1
    local colon = string.find(line, ":")
    local pipe = string.find(line, "|")
    local sub1 = string.sub(line, colon + 2, pipe - 2)
    local sub2 = string.sub(line, pipe + 2, -1)

    local nums = string.split(sub1, " ")
    local wins = string.split(sub2, " ")

    table.insert(numbers, { lineCount, nums })
    table.insert(winningNumbers, { lineCount, wins })
    table.insert(cardStack, { 1, lineCount })
end

local cardCount = 0
for i = 1, lineCount do
    local parts = cardStack[i]
    if parts == nil then break end
    local multpl = parts[1]
    local cardNum = parts[2]

    cardCount = cardCount + multpl
    local nums = numbers[cardNum][2]
    local wins = winningNumbers[cardNum][2]

    local winCount = 0
    for _, num in ipairs(nums) do
        for _, win in ipairs(wins) do
            if num == win then
                winCount = winCount + 1
                cardStack[i + winCount][1] = cardStack[i + winCount][1] + multpl
            end
        end
    end
end
print(cardCount)
