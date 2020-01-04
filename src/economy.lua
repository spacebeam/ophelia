--
-- Ugly 9734 economy hack for now since we are just testing stuff
-- it needs more than a couple of good'old clean, clean, clean.
--

-- add/remove if needed
local inspect = require("inspect")

local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")

local scouting = require("ophelia.scouting")

local economy = {}

local powering = true

local colonies = {}

local units = {["busy"]={}, ["idle"]={},
               ["scout"]={}, ["offence"]={},
               ["defence"]={}, ["harass"]={}}

local hatcheries = {}

local spawning_overlord = false

local scouting_overlords = {}

local scouting_drones = {}

local is_spawning_overlord = {}

local is_drone_scouting = false

local is_drone_expanding = false

-- Early, Make/defend a play & send colonies to one or two bases.
local early_stage = true
-- Middle, Core units, make/defend pressure & take a base.
local middle_stage = false
-- Late, Matured core units, multi-pronged tactics & take many bases.
local late_stage = false

function economy.check_workers()
    --
    -- check workers
    --
    local busy = {}
    for _, h in ipairs(hatcheries) do
        if h['id'] ~= nil then table.insert(busy, h['id']) end
    end
    for _, h in ipairs(scouting_drones) do
        if h['id'] ~= nil then table.insert(busy, h['id']) end
    end
    units['busy'] = busy
    return units
end

function economy.check_my_geysers(tc)
    --
    -- check my geysers
    --
    local geysers = {}
    for id, u in pairs(tc.state.units_neutral) do
        if u.type == tc.unittypes.Resource_Vespene_Geyser then
            table.insert(geysers, u.position)
        else
            tools.pass()
        end
    end
    return geysers
end

function economy.check_my_units(tc)
    --
    -- check my units
    --
    local larvae = {}
    local eggs = {}
    local overlords = {}
    local drones = {}
    local lings = {}
    local hydras = {}
    local mutas = {}
    local scourges = {}
    local lurkers = {}
    local queens = {}
    local defilers = {}
    local ultras = {}
    local guardians = {}
    local devourers = {}
    local infesteds = {}
    for id, u in pairs(tc.state.units_myself) do
        if u.type == tc.unittypes.Zerg_Overlord and u.flags.completed == true then
            table.insert(overlords, id)
        elseif u.type == tc.unittypes.Zerg_Zergling and u.flags.completed == true then
            table.insert(lings, id)
        elseif u.type == tc.unittypes.Zerg_Drone and u.flags.completed == true then
            table.insert(drones, id)
        elseif u.type == tc.unittypes.Zerg_Larva then
            table.insert(larvae, id)
        elseif u.type == tc.unittypes.Zerg_Egg then
            table.insert(eggs, id)
        elseif u.type == tc.unittypes.Zerg_Hydralisk and u.flags.completed == true then
            table.insert(hydras, id)
        elseif u.type == tc.unittypes.Zerg_Mutalisk and u.flags.completed == true then
            table.insert(mutas, id)
        elseif u.type == tc.unittypes.Zerg_Scourge and u.flags.completed == true then
            table.insert(scourges, id)
        elseif u.type == tc.unittypes.Zerg_Lurker and u.flags.completed == true then
            table.insert(lurkers, id)
        elseif u.type == tc.unittypes.Zerg_Queen and u.flags.completed == true then
            table.insert(queens, id)
        elseif u.type == tc.unittypes.Zerg_Defiler and u.flags.completed == true then
            table.insert(defilers, id)
        elseif u.type == tc.unittypes.Zerg_Ultralisk and u.flags.completed == true then
            table.insert(ultras, id)
        elseif u.type == tc.unittypes.Zerg_Guardian and u.flags.completed == true then
            table.insert(guardians, id)
        elseif u.type == tc.unittypes.Zerg_Devourer and u.flags.completed == true then
            table.insert(devourers, id)
        elseif u.type == tc.unittypes.Zerg_Infested_Terran and u.flags.completed == true then
            table.insert(infesteds, id)
        else
            tools.pass()
        end
    end
    units["overlords"] = overlords
    units["larvae"] = larvae
    units["eggs"] = eggs
    units["drones"] = drones
    units["lings"] = lings
    units["hydras"] = hydras
    units["mutas"] = mutas
    units["scourges"] = scourges
    units["lurkers"] = lurkers
    units["queens"] = queens
    units["defilers"] = defilers
    units["ultras"] = ultras
    units["guardians"] = guardians
    units["devourers"] = devourers
    units["infesteds"] = infesteds
    return units
end

function economy.take_natural(id, u, actions, tc)
    --
    -- take natural expansion
    --
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if hatcheries[1]['id'] == nil then hatcheries[1] = {["id"]=id} end
    if hatcheries[1]['id'] == id and not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"]))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"]))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["C"]["natural"]["x"], quadrants["C"]["natural"]["y"]))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"]))
        else print('economy.take_natural crash') end
    end
    return actions
end

function economy.build_natural(id, u, actions, tc)
    --
    -- build natural expansion
    --
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["C"]["natural"]["x"], quadrants["C"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        else print('economy.build_natural crash') end
    end
    return actions
end

function economy.take_third(id, u, actions, tc)
    --
    -- NOTE; you can't place this without scouting your enemy's position!
    --

    -- Send a drone to the main base opposite to your enemy's expand path.
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if hatcheries[2]['id'] == nil then hatcheries[2] = {["id"]=id} end
    if hatcheries[2]['id'] == id and not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"]))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"]))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"]))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Move, -1,
            quadrants["C"]["natural"]["x"], quadrants["C"]["natural"]["y"]))
        else print('economy.take_third crash') end
    end
    return actions
end

function economy.build_third(id, u, actions, tc)
    --
    -- Water machine build your third base
    --
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    -- where is enemy's start location?
    if not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        else print('economy.build_third crash') end
    end
    return actions
end


-- TODO: just after build your third, ger yourself an extractor!
function economy.build_main_extractor(id, u, actions, tc)
    --
    -- get gas, get gas, get gas!!!
    --
    -- check my geysers !?
    local geysers = economy.check_my_geysers(tc)
    if not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        --
        -- still need some gas
        --
        table.insert(actions,
        tc.command(tc.command_unit, id,
        tc.cmd.Build, -1,
        geysers[1][1], geysers[1][2],
        tc.unittypes.Zerg_Extractor))
    end
    return actions
end

function economy.take_fourth(id, u, actions, tc)
    --
    -- NOTE, location of 4th base depends on 3th.
    --
end

function economy.take_fifth()
    --
    -- NOTE, wait until you have darkswarm!
    --
end

function economy.manage_9734_simcity(actions, tc)
    --
    -- 9734 simcity management
    --
    for id, u in pairs(tc.state.units_myself) do
        if tc:isworker(u.type) then
            if is_drone_expanding and scouting_drones[1]['id'] ~= id
                and scouting_drones[2]['id'] ~= id and fun.size(hatcheries) == 1 then
                print('how are you ' .. id .. '?')
                actions = economy.take_natural(id, u, actions, tc)
                is_drone_expanding = false
            elseif fun.size(hatcheries) == 1 and hatcheries[1]['id'] == id
                and tc.state.resources_myself.ore >= 200 then
                print('how are you ' .. id .. '?')
                actions = economy.build_natural(id, u, actions, tc)
            elseif is_drone_expanding and scouting_drones[2]['id'] ~= id
                and fun.size(hatcheries) == 2 then
                actions = economy.take_third(id, u, actions, tc)
                is_drone_expanding = false
            elseif fun.size(hatcheries) == 2 and hatcheries[2]['id'] == id
                and tc.state.resources_myself.ore >= 300 then
                actions = economy.build_third(id, u, actions, tc)
            -- TODO: clean the simcity managment function
            elseif fun.size(hatcheries) == 2 and hatcheries[2]['id'] ~= id
                and tc.state.resources_myself.ore >= 50 then
                actions = economy.build_main_extractor(id, u, actions, tc)
            else
                tools.pass()
            end
        elseif tc:isbuilding(u.type) then
            if u.type == tc.unittypes.Zerg_Hatchery then
                -- Spawning ophelia's second overlord
                if spawning_overlord == true and fun.size(is_spawning_overlord) == 0 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[2] = true
                end
                -- Same for third overlord
                if spawning_overlord == true and fun.size(is_spawning_overlord) == 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[3] = true
                end
                -- Old count eggs base style
                if spawning_overlord == false and fun.size(is_spawning_overlord) == 1 then
                    if fun.size(units["overlords"]) == 1 and fun.size(units["eggs"]) < 1 then
                        is_spawning_overlord = {}
                        spawning_overlord = true
                    end
                end
                if spawning_overlord == true and fun.size(is_spawning_overlord) == 2 then
                    if fun.size(units["eggs"]) < 1 then
                        is_spawning_overlord[3] = nil
                    end
                end
                -- powering == drone up!
                if powering == true then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0,tc.unittypes.Zerg_Drone))
                end
            else
                tools.pass()
            end
        else
            tools.pass()
        end
    end
    return actions
end

function economy.manage_9734_workers(actions, tc)
    --
    -- 9734 worker management
    --
    for id, u in pairs(tc.state.units_myself) do
        if tc:isworker(u.type) then
            if is_drone_scouting and fun.size(scouting_drones) == 1 then
                local eleven = scouting.eleven_drone_scout(scouting_drones, id, u, actions, tc)
                actions = eleven["actions"]
                scouting_drones = eleven["scouting_drones"]
                is_drone_scouting = false
            elseif is_drone_scouting and scouting_drones[1]['id'] ~= id then
                local twelve = scouting.twelve_drone_scout(scouting_drones, id, u, actions, tc)
                actions = twelve["actions"]
                scouting_drones = twelve["scouting_drones"]
                is_drone_scouting = false
            elseif tc.state.resources_myself.ore >= 2000 then
                -- drones explore all the things!
                actions = scouting.explore_all_sectors(scouting_drones, id, u, actions, tc)
            else
                -- We Require More Vespene Gas!
                if fun.find(units['busy'], id) == nil and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Gather])
                    and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    -- still missing gas!
                    local target = tools.get_closest(u.position,
                        tc:filter_type(tc.state.units_neutral,
                        {tc.unittypes.Resource_Mineral_Field,
                         tc.unittypes.Resource_Mineral_Field_Type_2,
                         tc.unittypes.Resource_Mineral_Field_Type_3}))
                    if target ~= nil then
                        table.insert(actions,
                        tc.command(tc.command_unit_protected, id,
                        tc.cmd.Right_Click_Unit, target))
                    end
                end
            end
        end
    end
    units = economy.check_workers()
    -- First created overlord, second in total.. this is the 'overpool' overlord.
    if fun.size(units['drones']) == 9 and fun.size(units['overlords']) == 1
        and fun.size(is_spawning_overlord) == 0 and spawning_overlord == false then
        spawning_overlord = true
    end
    -- Scouting at 11
    if fun.size(units['drones']) == 11 and scouting_drones[1] == nil then
        scouting_drones[1] = {}
        is_drone_scouting = true
    end
    -- Scouting at 12
    if fun.size(units['drones']) == 12 and scouting_drones[2] == nil then
        scouting_drones[2] = {}
        is_drone_scouting = true
    end
    -- at 12 taking natural after 'overpool'
    if fun.size(units['drones']) == 12 and scouting_drones[2] ~= nil
        and hatcheries[1] == nil then
        -- WTF ?
        hatcheries[1] = {}
        is_drone_expanding = true
    end
    -- at 13 taking another natural
    if fun.size(units['drones']) == 13 and scouting_drones[2] ~= nil
        and hatcheries[2] == nil then
        hatcheries[2] = {}
        is_drone_expanding = true
    end
    -- at 16 building the third overlord
    if fun.size(units['drones']) == 16 and fun.size(units['overlords']) == 2
        and spawning_overlord == false then
        spawning_overlord = true
    end
    -- init 9734 test workers
    if fun.size(units['drones']) >= 19 then
        powering = false
    else powering = true end
    -- stop drone powering at 12 focus change to 3th expansion and gas
    if fun.size(units['drones']) >= 12 then
        powering = false
    else powering = true end
    -- gg
    return actions
end

function economy.manage_9734_economy(actions, tc)
    --
    -- What exactly is macro, anyway?
    -- this interpretation includes 'powering'.
    -- powering is when computer switch to primarily
    -- economics, making drones and new extractors.
    --
    local units = economy.check_my_units(tc)

    -- check my geysers !?
    local geysers = economy.check_my_geysers(tc)
    print(inspect(geysers))
    -- Set your units into 3 groups, collapse each on
    -- different sides of the enemy for maximum effectiveness.
    local offence = {}
    units['offence'] = offence
    -- Defense powerful but immobile, offence mobile but weak
    local defence = {}
    units['defence'] = defence
    -- Scout identify enemy units
    local enemy = scouting.identify_enemy_units(tc)
    units['enemy'] = enemy
    -- And Now For Something Completely Different
    actions = economy.manage_9734_simcity(actions, tc)
    actions = economy.manage_9734_workers(actions, tc)
    print("overlords " .. fun.size(units['overlords']))
    print("larvae ".. fun.size(units['larvae']))
    print("eggs " .. fun.size(units['eggs']))
    print("drones " .. fun.size(units['drones']))
    print("lings " .. fun.size(units['lings']))
    print("hydras " .. fun.size(units['hydras']))
    print("lurkers " .. fun.size(units['lurkers']))
    print("mutas " .. fun.size(units['mutas']))
    print("scourges " .. fun.size(units['scourges']))
    print("queens " .. fun.size(units['queens']))
    print("defilers " .. fun.size(units['defilers']))
    print("ultras " .. fun.size(units['ultras']))
    print("guardians " .. fun.size(units['guardians']))
    print("devourers " .. fun.size(units['devourers']))
    print("infesteds " .. fun.size(units['infesteds']))
    -- So long and thanks for all the fish!
    return actions
end

return economy
