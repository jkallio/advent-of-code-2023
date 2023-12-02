local file = io.open("input", "r")

if file == nil then
    print("Error opening file")
    return
end

local sum = 0
for line in file:lines() do
    local first_digit
    local last_digit
    for c in line:gmatch("%d") do
        if first_digit == nil then
            first_digit = c
        end
        last_digit = c
    end
    local value = tonumber(first_digit .. last_digit)
    if value == nil then
        print("Error converting to number")
        file:close()
        return
    end
    sum = sum + value
end
print(sum)

file:close()
