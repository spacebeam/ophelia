--
-- Put effort into make a good set of tools which allow to build custom solutions. 
--

local utils = require("torchcraft.utils")

local tools = {}

function tools.this_is()
    print("only a test")
end

function tools.check_supported_maps(name)
    --
    -- A map is not the territory
    --
    -- Check here for supported maps only;
    -- also a good place to move/add/return;
    -- start_locations, previous map analysis, etc.
    --
    if string.match(name, "Fighting Spirit") then
        print("Fighting Spirit")
    elseif string.match(name, "CircuitBreakers") then
        print("CircuitBreakers")
    elseif string.match(name, "Gladiator") then
        print("Gladiator")
    elseif string.match(name, "Sparkle") then
        print("Sparkle")
    elseif string.match(name, "Power Bond") then
        print("Power Bond")
    elseif string.match(name, "Neo Aztec") then
        print("Neo Aztec")
    elseif string.match(name, "Gold Rush") then
        print("Gold Rush")
    elseif string.match(name, "Overwatch") then
        print("Overwatch")
    elseif string.match(name, "Heartbreak Ridge") then
        print("Heartbreak Ridge")
    elseif string.match(name, "Blue Storm") then
        print("Blue Storm")
    else
        print("crash something else")
    end
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
