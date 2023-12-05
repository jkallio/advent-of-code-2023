local file = io.open("input", "r")
if not file then
    print("File not found")
    return
end

--- Create a key from x and y
local function createKey(x, y)
    return tostring(x) .. ":" .. tostring(y)
end

--- Get the value at x and y
local function getCoords(key)
    local x, y = key:match("(%d+):(%d+)")
    return tonumber(x), tonumber(y)
end

--- Return the number at x and y (or nil)
local function getDigit(map, x, y)
    local key = createKey(x, y)
    return tonumber(map[key])
end

--- Return the entire number value that x and y is part of (or nil)
local function getNumber(map, x, y)
    if not getDigit(map, x, y) then
        local i = 1
        local numbr = ""
        while true do
            local digit = getDigit(map, x + i, y)
            if digit then
                numbr = numbr .. tostring(digit)
                i = i + 1
            else
                return createKey(x, y), tonumber(numbr)
            end
        end
    else
        return getNumber(map, x - 1, y)
    end
end

--- First find all the characters that are next to a number (let's call them seekers)
local map = {}
local seekers = {}
local y = 1
for line in file:lines() do
    for x = 1, #line do
        local c = line:sub(x, x)
        map[createKey(x, y)] = c
        if string.match(c, "[^%d%.]") then
            seekers[createKey(x, y)] = c
        end
    end
    y = y + 1
end

--- Then find all the numbers that are next to a seeker
local sum = 0
for coords, seeker in pairs(seekers) do
    local gears = {}
    if seeker == "*" then
        local x, y = getCoords(coords)
        local parts = {}
        for i = -1, 1 do
            for j = -1, 1 do
                local digit = getDigit(map, x + i, y + j)
                if digit then
                    local key, num = getNumber(map, x + i, y + j)
                    gears[key] = num
                end
            end
        end
    end
    local count = 0
    local ratio = 1
    for _, value in pairs(gears) do
        count = count + 1
        ratio = ratio * value
    end
    if count == 2 then
        sum = sum + ratio
    end
end
print("Sum of gear ratios: ", sum)
