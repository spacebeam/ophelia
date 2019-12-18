--
-- Put effort into make a good set of tools which allow to build custom solutions. 
--

local utils = require("torchcraft.utils")

local tools = {}

function tools.this_is()
    print("only a test")
end

function tools.check_supported_maps(fname)
    --
    -- A map is not the territory
    --
    -- Check here for supported maps only;
    -- also a good place to move/add/return;
    -- start_locations, previous map analysis, etc.
    --
    if string.match(fname, "Fighting Spirit") then
        print("Fighting Spirit")
    elseif string.match(fname, "CircuitBreakers") then
        print("CircuitBreakers")
    elseif string.match(fname, "Gladiator") then
        print("Gladiator")
    elseif string.match(fname, "Sparkle") then
        print("Sparkle")
    elseif string.match(fname, "Power Bond") then
        print("Power Bond")
    elseif string.match(fname, "Neo Aztec") then
        print("Neo Aztec")
    elseif string.match(fname, "Gold Rush") then
        print("Gold Rush")
    elseif string.match(fname, "Overwatch") then
        print("Overwatch")
    elseif string.match(fname, "Heartbreak Ridge") then
        print("Heartbreak Ridge")
    elseif string.match(fname, "Blue Storm") then
        print("Blue Storm")
    else
        print("crash something else")
    end
end

function tools.get_closest(position, units)
    local min_d = 1E30
    local closest_uid = nil
    for uid, ut in pairs(units) do
        local tmp_d = utils.distance(position, ut['position'])
        if tmp_d < min_d then
            min_d = tmp_d
            closest_uid = uid
        end
    end
    return closest_uid
end

return tools
