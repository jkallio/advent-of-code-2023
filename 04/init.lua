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

local total = 0
for line in file:lines() do
    local colon = string.find(line, ":")
    local pipe = string.find(line, "|")
    local sub1 = string.sub(line, colon + 2, pipe - 2)
    local sub2 = string.sub(line, pipe + 2, -1)

    local nums = string.split(sub1, " ")
    local pool = string.split(sub2, " ")

    local points = 0
    for _, num in ipairs(nums) do
        for _, p in ipairs(pool) do
            if num == p then
                if points == 0 then
                    points = 1
                else
                    points = points * 2
                end
            end
        end
    end
    print(sub1 .. " --|-- " .. sub2 .. " --|-- " .. points)
    total = total + points
end
print("Total:", total)
