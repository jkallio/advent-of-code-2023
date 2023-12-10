local file = io.open("input", "r")
if not file then
    print("File not found")
    os.exit()
end

--- returns true if str starts with start
local starts_with = function(str, start)
    return str:sub(1, #start) == start
end


local seeds = {}
local seed_to_soil = {}
local soil_to_fertilizer = {}
local fertilizer_to_water = {}
local water_to_light = {}
local light_to_temp = {}
local temp_to_humid = {}
local humid_to_loc = {}
local parse_input = function(file)
    local ParseMode = {
        seeds = 0,
        seed_to_soil = 1,
        soil_to_fert = 2,
        fert_to_water = 3,
        water_to_light = 4,
        light_to_temp = 5,
        temp_to_humid = 6,
        humid_to_loc = 7,
    }

    local mode = ParseMode.seeds
    for line in file:lines() do
        if starts_with(line, "seeds:") then
            for seed in line:gmatch("%d+") do
                table.insert(seeds, tonumber(seed))
            end
        elseif starts_with(line, "seed-to-soil map:") then
            mode = ParseMode.seed_to_soil
        elseif starts_with(line, "soil-to-fertilizer map:") then
            mode = ParseMode.soil_to_fert
        elseif starts_with(line, "fertilizer-to-water map:") then
            mode = ParseMode.fert_to_water
        elseif starts_with(line, "water-to-light map:") then
            mode = ParseMode.water_to_light
        elseif starts_with(line, "light-to-temperature map:") then
            mode = ParseMode.light_to_temp
        elseif starts_with(line, "temperature-to-humidity map:") then
            mode = ParseMode.temp_to_humid
        elseif starts_with(line, "humidity-to-location map:") then
            mode = ParseMode.humid_to_loc
        elseif line ~= "" then
            local dest, src, len = line:match("(%d+) (%d+) (%d+)")
            if mode == ParseMode.seed_to_soil then
                table.insert(seed_to_soil, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            elseif mode == ParseMode.soil_to_fert then
                table.insert(soil_to_fertilizer, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            elseif mode == ParseMode.fert_to_water then
                table.insert(fertilizer_to_water, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            elseif mode == ParseMode.water_to_light then
                table.insert(water_to_light, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            elseif mode == ParseMode.light_to_temp then
                table.insert(light_to_temp, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            elseif mode == ParseMode.temp_to_humid then
                table.insert(temp_to_humid, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            elseif mode == ParseMode.humid_to_loc then
                table.insert(humid_to_loc, { dest = tonumber(dest), src = tonumber(src), len = tonumber(len) })
            end
        end
    end
end

parse_input(file)
file:close()

local lowest = nil
for _, seed in ipairs(seeds) do
    print("Seed: ", seed)

    local soil = seed
    for _, sts in ipairs(seed_to_soil) do
        if seed >= sts.src and seed < sts.src + sts.len then
            soil = sts.dest + (seed - sts.src)
        end
    end
    print("Soil: ", soil)

    local fertilizer = soil
    for _, stf in ipairs(soil_to_fertilizer) do
        if soil >= stf.src and soil < stf.src + stf.len then
            fertilizer = stf.dest + (soil - stf.src)
        end
    end
    print("Fertilizer: ", fertilizer)

    local water = fertilizer
    for _, ftw in ipairs(fertilizer_to_water) do
        if fertilizer >= ftw.src and fertilizer < ftw.src + ftw.len then
            water = ftw.dest + (fertilizer - ftw.src)
        end
    end
    print("Water: ", water)

    local light = water
    for _, wtl in ipairs(water_to_light) do
        if water >= wtl.src and water < wtl.src + wtl.len then
            light = wtl.dest + (water - wtl.src)
        end
    end
    print("Light: ", light)

    local temp = light
    for _, ltt in ipairs(light_to_temp) do
        if light >= ltt.src and light < ltt.src + ltt.len then
            temp = ltt.dest + (light - ltt.src)
        end
    end
    print("Temperature: ", temp)

    local humid = temp
    for _, tth in ipairs(temp_to_humid) do
        if temp >= tth.src and temp < tth.src + tth.len then
            humid = tth.dest + (temp - tth.src)
        end
    end
    print("Humidity: ", humid)

    local loc = humid
    for _, htl in ipairs(humid_to_loc) do
        if humid >= htl.src and humid < htl.src + htl.len then
            loc = htl.dest + (humid - htl.src)
        end
    end
    print("Location: ", loc)

    if lowest == nil or loc < lowest then
        lowest = loc
    end
    print()
end

print("Lowest: ", lowest)
