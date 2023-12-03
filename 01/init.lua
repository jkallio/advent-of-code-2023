local file = io.open("input", "r")

if file == nil then
    print("Error opening file")
    return
end

local search_strings = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero" }
local sum = 0
for line in file:lines() do
    local first_digit
    local last_digit

    for i = 1, #line do
        local digit = line:sub(i, i)
        local num = tonumber(digit)
        if num == nil then
            for j, search_num in ipairs(search_strings) do
                local substr = line:sub(i, i + #search_num - 1)
                if substr == search_num then
                    digit = tostring(j)
                    break
                end
            end
            num = tonumber(digit)
        end

        if num ~= nil then
            if first_digit == nil then
                first_digit = digit
            end
            last_digit = digit
        end
    end

    local value = tonumber(first_digit .. last_digit)
    sum = sum + value
end

print(sum)
file:close()
