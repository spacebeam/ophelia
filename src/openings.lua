--
-- 9 Pool
-- Gas 9
-- Overpool
-- 12 Hatch
--

-- add/remove if needed
--local inspect = require("inspect")

--local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")

local openings = {}

local has_spawning_pool = false

local has_hydralisk_den = false

local spawning_pool = 0

local hydralisk_den = 0

local main = false


function openings.ninepool(actions, tc)
    --
    -- Standard ZvZ
    --
    return actions
end

function openings.gasnine(actions, tc)
    --
    -- One base ZvZ fast muta opening
    --
    return actions
end

function openings.build_973_den(actions, tc)
    --
    -- Build hydralisk den
    --
    for id, u in pairs(tc.state.units_myself) do
        if tc:isworker(u.type) then
            if has_hydralisk_den == false and tc.state.resources_myself.ore >= 100
                and tc.state.resources_myself.gas >= 50
                and tc.state.frame_from_bwapi - hydralisk_den > 150 then
                hydralisk_den = tc.state.frame_from_bwapi
                if main.position ~= nil and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, id,
                    tc.cmd.Build, -1,
                    main.position[1] - 4, main.position[2] + 18, tc.unittypes.Zerg_Hydralisk_Den))
                end
            end
        elseif tc:isbuilding(u.type) then
            if u.type == tc.unittypes.Zerg_Hydralisk_Den then
                if has_hydralisk_den == false then has_hydralisk_den = true end
            end
        else
            tools.pass()
        end
    end
    return actions
end

function openings.overpool(actions, tc)
    --
    -- Safe standard opening
    --
    for id, u in pairs(tc.state.units_myself) do
        if tc:isworker(u.type) then
            if has_spawning_pool == false and tc.state.resources_myself.ore >= 200
                and tc.state.frame_from_bwapi - spawning_pool > 190 then
                spawning_pool = tc.state.frame_from_bwapi
                local _, unit = next(tc:filter_type(tc.state.units_myself, {tc.unittypes.Zerg_Hatchery}))
                if not main then
                    main = unit
                end
                if main.position ~= nil and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, id,
                    tc.cmd.Build, -1,
                    main.position[1] - 4, main.position[2] + 12, tc.unittypes.Zerg_Spawning_Pool))
                end
            end
        elseif tc:isbuilding(u.type) then
            if u.type == tc.unittypes.Zerg_Spawning_Pool then
                if has_spawning_pool == false then has_spawning_pool = true end
            end
        else
            tools.pass()
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
