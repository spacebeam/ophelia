-- overpool, overgas, 11 hatch
local Opening = tiny.processingSystem(class("Opening"))
--
-- Overpool
-- Overgas
-- 11 Hatch
--

local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")

local openings = {}

-- can we just read stuff from the structure on "economy" ?
local has_spawning_pool = false

local spawning_pool = 0

local main = false

function openings.eleven_hatch(actions, tc)
    --
    -- 11 hatch
    --
    return actions
end

function openings.twelve_pool(id, u, actions, tc)
    --
    -- Safe ZvZ opening against 9pool
    --
    if tc:isworker(u.type) then
        if has_spawning_pool == false and tc.state.resources_myself.ore >= 200 then
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
    return actions
end

function openings.overpool(actions, tc)
    --
    -- Safe standard opening vs Protoss FFE
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

function openings.overgas(actions, tc)
    --
    -- Over gas
    --
end

Opening.filter = tiny.requireAll("opening")

function Opening:process(e, dt)
	e:opening(dt)
end

return Opening