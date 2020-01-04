--
-- Put effort into make a good set of tools which allow to build custom solutions.
--

local utils = require("torchcraft.utils")

local tools = {}

function tools.this_is()
    print("only a test")
end

function tools.pass()
    -- do nothing
    return 'ok'
end

function tools.check_supported_maps(name)
    --
    -- A map is not the territory
    --
    -- Check here for supported maps only;
    -- also a good place to move/add/return;
    -- start_locations, previous map analysis, etc.
    --
    local map = {}
    if string.match(name, "Fighting Spirit") then
        map['bases'] = 4
    elseif string.match(name, "CircuitBreakers") then
        map['bases'] = 4
    elseif string.match(name, "Gladiator") then
        map['bases'] = 4
    elseif string.match(name, "Sparkle") then
        map['bases'] = 4
    elseif string.match(name, "Power Bond") then
        print("Power Bond")
        map['bases'] = 3
    elseif string.match(name, "Neo Aztec") then
        print("Neo Aztec")
        map['bases'] = 3
    elseif string.match(name, "Gold Rush") then
        print("Gold Rush")
        map['bases'] = 3
    elseif string.match(name, "Overwatch") then
        print("Overwatch")
        map['bases'] = 2
    elseif string.match(name, "Heartbreak Ridge") then
        print("Heartbreak Ridge")
        map['bases'] = 2
    elseif string.match(name, "Blue Storm") then
        map['bases'] = 2
    else
        print("crash something else")
    end
    return map
end

function tools.get_closest(position, units)
    local min_d = 1E30
    local closest_id = nil
    for id, u in pairs(units) do
        local tmp_d = utils.distance(position, u['position'])
        if tmp_d < min_d then
            min_d = tmp_d
            closest_id = id
        end
    end
    return closest_id
end

return tools
