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
        table.insert(result, part)
        lastPos = pos
    end
    if lastPos and lastPos <= #self then
        local lastPart = self:sub(lastPos)
        lastPart = lastPart:trim()
        table.insert(result, lastPart)
    end
    return result
end

--- Count Number of RGB colors in a set
--- @param set string Comma separated list of RGB colors with count (e.g. "1 red, 2 green, 3 blue")
local function countRgb(set)
    local count = { 0, 0, 0 }
    local rgb_parts = set:split(",")
    if #rgb_parts == 0 then
        rgb_parts = { set }
    end
    for _, color_count in ipairs(rgb_parts) do
        local color_parts = color_count:split(" ")
        if color_parts[2] == "red" then
            count[1] = tonumber(color_parts[1])
        elseif color_parts[2] == "green" then
            count[2] = tonumber(color_parts[1])
        elseif color_parts[2] == "blue" then
            count[3] = tonumber(color_parts[1])
        else
            print("Unknown color: " .. color_parts[2])
        end
    end
    return count
end

local max_rgb = { 12, 13, 14 }
local sum = 0
for line in file:lines() do
    local line_parts = line:split(":")
    local game_index_parts = line_parts[1]:split(" ")
    local index = tonumber(game_index_parts[2])

    local parts = line_parts[2]:split(";")
    local seen_rgb = { 0, 0, 0 }
    for _, part in ipairs(parts) do
        local rgb_count = countRgb(part)
        for j, count in ipairs(rgb_count) do
            if count > seen_rgb[j] then
                seen_rgb[j] = count
            end
        end
    end
    if seen_rgb[1] <= max_rgb[1] and seen_rgb[2] <= max_rgb[2] and seen_rgb[3] <= max_rgb[3] then
        sum = sum + index
        print(index .. ": (" .. seen_rgb[1] .. "," .. seen_rgb[2] .. "," .. seen_rgb[3] .. ")")
    end
end
print("Sum of IDs: " .. sum)
