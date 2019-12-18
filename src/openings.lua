--
-- 9 Pool
-- Overpool
-- 12 Hatch
--

-- add/remove if needed
local inspect = require("inspect")

local fun = require("moses")
local utils = require("torchcraft.utils")

local openings = {}

local has_spawning_pool = false

local spawning_pool = 0

function openings.ninepool(actions, tc)
    --
    -- Standard ZvZ 
    --
    return actions
end

function openings.overpool(actions, tc)
    --
    -- Safe standard opening
    --
    for uid, ut in pairs(tc.state.units_myself) do
        if tc:isworker(ut.type) then
            if has_spawning_pool == false and tc.state.resources_myself.ore >= 200
                and tc.state.frame_from_bwapi - spawning_pool > 190 then
                spawning_pool = tc.state.frame_from_bwapi
                local _, pos = next(tc:filter_type(tc.state.units_myself, {tc.unittypes.Zerg_Hatchery}))
                if pos ~= nil then pos = pos.position end
                if pos ~= nil and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Build, -1,
                    pos[1], pos[2] + 16, tc.unittypes.Zerg_Spawning_Pool))
                end
            end
        elseif tc:isbuilding(ut.type) then
            if ut.type == tc.unittypes.Zerg_Spawning_Pool then
                if has_spawning_pool == false then has_spawning_pool = true end
            end
        else
            -- crash or ignore?
        end
    end
    return actions
end

function openings.twelve_hatch(actions, tc)
    --
    -- Greed economic opening
    --
    -- NOTE: If you are doing 12th hatch, scouting 1th overlord in cross position.
    --
    return actions
end

return openings
