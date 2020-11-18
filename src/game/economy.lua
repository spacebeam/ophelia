--
-- This game is all about information economy
--
-- What exactly is macro, anyway?
-- this interpretation includes 'powering'.
-- powering is when computer switch to economics.
--

-- zvp mindset: have enough drones with 6 hatches and 3 gas mining
-- zvp mindset: lets learn to survive and use mutalisks for now!

local inspect = require("inspect")

local fun = require("moses")
local utils = require("torchcraft.utils")
local scouting = require("ophelia.scouting")
local openings = require("ophelia.openings")
local tools = require("ophelia.tools")

-- old opening stuff have has_spawning_pool, spawning_pool as bool
-- old opening got main hatchery position from list of buildings

-- here we don't need a main variable in reference to the first hatch
-- here we got a list of all our buildings and units.

-- This quandrant stuff is relevant only to our implementation
-- players use the clock to position themselves on the map.
local quadrant = false
local quadrants = false

-- This is all about economy
local economy = {}

local powering = true

local buildings = {["hatcheries"]={},
                   ["spawning_pool"]={},
                   ["extractors"]={},
                   ["evolution_chambers"]={},
                   ["hydralisk_den"]={},
                   ["lair"]={},
                   ["hive"]={},
                   ["queen_nest"]={},
                   ["spire"]={}}

local units = {["busy"]={},
               ["idle"]={},
               ["scout"]={},
               ["offence"]={},
               ["defence"]={},
               ["buildings"]={},
               ["spawning"]=buildings,
               ["geysers"]={}}

local expansions = {}

local scouting_drones = {}

local spawning_overlord = false

local spawning_lings = false

local spawning_hydras = false

local is_spawning_overlord = {}

local is_drone_scouting = false

local is_drone_expanding = false

local vespene_drones = {}

local drones_to_gas = false


function economy.check_workers()
    --
    -- check workers
    --
    local busy = {}
    -- this is probably all wrong!
    for _, x in ipairs(expansions) do
        if x['id'] ~= nil then table.insert(busy, x['id']) end
    end
    for _, d in ipairs(scouting_drones) do
        if d['id'] ~= nil then table.insert(busy, d['id']) end
    end
    for _, e in ipairs(units['spawning']['extractors']) do
        if e['id'] ~= nil then table.insert(busy, e['id']) end
    end
    for _, h in ipairs(units['spawning']['hydralisk_den']) do
        if h['id'] ~= nil then table.insert(busy, h['id']) end
    end
    for _, g in ipairs(vespene_drones) do
        if g['id'] ~= nil then table.insert(busy, g['id']) end
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
    local hatcheries = {}
    local extractors = {}
    local spawning_pool = {}
    local hydralisk_den = {}
    local evolution_chambers = {}
    local creep_colonies = {}
    local sunken_colonies = {}
    local spore_colonies = {}
    local lair = {}
    local spire = {}
    local queens_nest = {}
    local hive = {}
    local defiler_mound = {}
    local ultralisk_cavern = {}
    local infested_command_center = {}
    local nydus_canals = {}
    for id, u in pairs(tc.state.units_myself) do
        if u.type == tc.unittypes.Zerg_Overlord and u.flags.completed == true then
            table.insert(overlords, id)
        elseif u.type == tc.unittypes.Zerg_Zergling then
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
        elseif u.type == tc.unittypes.Zerg_Hatchery then
            table.insert(hatcheries, {["id"]=id, ["position"]=u.position})
        elseif u.type == tc.unittypes.Zerg_Extractor and u.flags.completed == true then
            table.insert(extractors, id)
        elseif u.type == tc.unittypes.Zerg_Spawning_Pool and u.flags.completed == true then
            table.insert(spawning_pool, id)
        elseif u.type == tc.unittypes.Zerg_Hydralisk_Den and u.flags.completed == true then
            table.insert(hydralisk_den, id)
        elseif u.type == tc.unittypes.Zerg_Evolution_Chamber and u.flags.completed == true then
            table.insert(evolution_chambers, id)
        elseif u.type == tc.unittypes.Zerg_Creep_Colony and u.flags.completed == true then
            table.insert(creep_colonies, id)
        elseif u.type == tc.unittypes.Zerg_Sunken_Colony and u.flags.completed == true then
            table.insert(sunken_colonies, id)
        elseif u.type == tc.unittypes.Zerg_Spore_Colony and u.flags.completed == true then
            table.insert(spore_colonies, id)
        elseif u.type == tc.unittypes.Zerg_Lair and u.flags.completed == true then
            table.insert(lair, id)
        elseif u.type == tc.unittypes.Zerg_Spire and u.flags.completed == true then
            table.insert(spire, id)
        elseif u.type == tc.unittypes.Zerg_Queens_Nest and u.flags.completed == true then
            table.insert(queens_nest, id)
        elseif u.type == tc.unittypes.Zerg_Hive and u.flags.completed == true then
            table.insert(hive, id)
        elseif u.type == tc.unittypes.Zerg_Defiler_Mound and u.flags.completed == true then
            table.insert(defiler_mound, id)
        elseif u.type == tc.unittypes.Zerg_Ultralisk_Cavern and u.flags.completed == true then
            table.insert(ultralisk_cavern, id)
        elseif u.type == tc.unittypes.Zerg_Nydus_Canal and u.flags.completed == true then
            table.insert(nydus_canals, id)
        elseif u.type == tc.unittypes.Zerg_Infested_Command_Center and u.flags.completed == true then
            table.insert(infested_command_center, id)
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
    units["buildings"]["hatcheries"] = hatcheries
    units["buildings"]["spawning_pool"] = spawning_pool
    units["buildings"]["extractors"] = extractors
    units["buildings"]["evolution_chambers"] = evolution_chambers
    units["buildings"]["hydralisk_den"] = hydralisk_den
    units["buildings"]["creep_colonies"] = creep_colonies
    units["buildings"]["sunken_colonies"] = sunken_colonies
    units["buildings"]["spore_colonies"] = spore_colonies
    units["buildings"]["lair"] = lair
    units["buildings"]["spire"] = spire
    units["buildings"]["queens_nest"] = queens_nest
    units["buildings"]["infested_command_center"] = infested_command_center
    -- missing late game tech for obvious reasons!
    return units
end

function economy.take_natural(id, u, actions, tc)
    --
    -- take natural expansion
    --
    if expansions[1]['id'] == nil then expansions[1] = {["id"]=id} end
    if expansions[1]['id'] == id and not utils.is_in(u.order,
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
    -- TODO; you can't place this without scouting your enemy's position!
    --
    -- Send a drone to the main base opposite to your enemy's expand path.
    if expansions[2]['id'] == nil then expansions[2] = {["id"]=id} end
    if expansions[2]['id'] == id and not utils.is_in(u.order,
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
    -- Machine build your third base
    --
    -- TODO: where is my enemy's start location?
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

function economy.take_main_geyser(id, u, actions, tc)
    --
    -- Take main geyser
    --
    if units['spawning']['extractors'][1] == nil then units['spawning']['extractors'][1] = {["id"]=id} end
    if units['spawning']['extractors'][1]['id'] == id and not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        table.insert(actions,
        tc.command(tc.command_unit, id,
        tc.cmd.Move, -1,
        units['geysers'][1][1], units['geysers'][1][2]))
    end
    return actions
end

function economy.build_main_extractor(id, u, actions, tc)
    --
    -- Build main extractor
    --
    if units['spawning']['extractors'][1]['id'] == id and not utils.is_in(u.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        table.insert(actions,
        tc.command(tc.command_unit, id,
        tc.cmd.Build, -1,
        units['geysers'][1][1] - 8, units['geysers'][1][2] - 4,
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
    -- NOTE, wait until you have defiler!
    --
end

function economy.build_hydralisk_den(id, u, actions, tc)
    --
    -- Build hydralisk den
    --
    if units['spawning']['hydralisk_den'][1] == nil then
        units['spawning']['hydralisk_den'][1] = {["id"]=id}
    end
    if units['spawning']['hydralisk_den'][1]["id"] == id and tc.state.resources_myself.ore >= 100
        and tc.state.resources_myself.gas >= 50 then
        if units['buildings']['hatcheries'][1]['position'] ~= nil and not utils.is_in(u.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, id,
            tc.cmd.Build, -1,
            units['buildings']['hatcheries'][1]['position'][1] - 4,
            units['buildings']['hatcheries'][1]['position'][2] + 18,
            tc.unittypes.Zerg_Hydralisk_Den))
        end
    end
    return actions
end

function economy.manage_9734_bo(actions, tc)
    --
    -- 9734 worker management
    --
    local map = tools.check_supported_maps(tc.state.map_name)

    actions = scouting.first_overlord(actions, map, tc)

    actions = openings.overpool(actions, tc)

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
            elseif is_drone_expanding and scouting_drones[1]['id'] ~= id
                and scouting_drones[2]['id'] ~= id and fun.size(expansions) == 1 then
                actions = economy.take_natural(id, u, actions, tc)
                is_drone_expanding = false
            elseif fun.size(expansions) == 1 and expansions[1]['id'] == id
                and tc.state.resources_myself.ore >= 300 then
                actions = economy.build_natural(id, u, actions, tc)
            elseif is_drone_expanding and scouting_drones[2]['id'] ~= id
                and fun.size(expansions) == 2 then
                actions = economy.take_third(id, u, actions, tc)
                is_drone_expanding = false
            elseif fun.size(expansions) == 2 and expansions[2]['id'] ~= nil
                and tc.state.resources_myself.ore >= 300 then
                actions = economy.build_third(scouting_drones[1]['id'], u, actions, tc)
            elseif fun.size(expansions) == 2
                and units['spawning']['extractors'][1] == nil
                and expansions[1]['id'] ~= id
                and expansions[2]['id'] ~= id
                and scouting_drones[1]['id'] ~= id
                and scouting_drones[2]['id'] ~= id
                and tc.state.resources_myself.ore >= 42 then
                actions = economy.take_main_geyser(id, u, actions, tc)
            elseif units['spawning']['extractors'][1] ~= nil
                and fun.size(units['buildings']['extractors']) ~= 1
                and tc.state.resources_myself.ore >= 50 then
                actions = economy.build_main_extractor(units['spawning']['extractors'][1]['id'], u, actions, tc)
            -- Sending drones to extractor
            elseif drones_to_gas
                and expansions[1]['id'] ~= id
                and expansions[2]['id'] ~= id
                and scouting_drones[1]['id'] ~= id
                and scouting_drones[2]['id'] ~= id
                and vespene_drones[3] == nil then
                if fun.size(vespene_drones) == 0 then
                    vespene_drones[1] = {["id"]=id}
                    -- clean and reformat this into its own function
                    table.insert(actions,
                    tc.command(tc.command_unit_protected, id,
                    tc.cmd.Right_Click_Unit, units['buildings']['extractors'][1]))
                elseif fun.size(vespene_drones) == 1 and vespene_drones[1]["id"] ~= id then
                    vespene_drones[2] = {["id"]=id}
                    table.insert(actions,
                    tc.command(tc.command_unit_protected, id,
                    tc.cmd.Right_Click_Unit, units['buildings']['extractors'][1]))
                elseif fun.size(vespene_drones) == 2 and vespene_drones[2]["id"] ~= id then
                    vespene_drones[3] = {["id"]=id}
                    table.insert(actions,
                    tc.command(tc.command_unit_protected, id,
                    tc.cmd.Right_Click_Unit, units['buildings']['extractors'][1]))
                end
            -- init test on hydralisk den
            else
                units = economy.check_workers()
                if fun.find(units['busy'], id) == nil and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Gather])
                    and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                   and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
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
            units = economy.check_workers()
            -- this does not belong here!
            actions = economy.build_hydralisk_den(id, u, actions, tc)
            -- explore all things!
            if tc.state.resources_myself.ore >= 2000 then
                -- drones explore all the things!
                actions = scouting.explore_all_sectors(id, u, actions, tc)
            end
        end
    end
    print(inspect(units['busy']))
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
    if fun.size(units['drones']) == 12 and fun.size(scouting_drones) == 2
        and expansions[1] == nil then
        expansions[1] = {}
        is_drone_expanding = true
    end
    -- at 12 expanding the 3th hatch
    if fun.size(units['drones']) == 12
        and fun.size(scouting_drones) == 2
        and fun.size(units['buildings']['hatcheries']) == 2
        and expansions[2] == nil then
        expansions[2] = {}
        is_drone_expanding = true
    end
    -- at 16 building the third overlord
    if fun.size(units['drones']) >= 16 and fun.size(units['overlords']) == 2
        and spawning_overlord == false then
        spawning_overlord = true
    end
    -- init 9734 test workers
    if fun.size(units['drones']) >= 22 then
        powering = false
    else powering = true end
    -- stop drone powering at 12 focus change to 3th expansion and gas
    if fun.size(units['drones']) == 12 then
        powering = false
    end
    -- gg
    return actions
end

function economy.manage_5hh_bo(actions, tc)
    --
    -- 5HH worker management
    --
    return actions
end

function economy.manage_2hm_bo(actions, tc)
    --
    -- 2HM worker management
    --
    return actions
end

function economy.manage_10p_bo(actions, tc)
    --
    -- 10P worker management
    --
    return actions
end

function economy.manage_12p_bo(actions, tc)
    --
    -- 12p worker management
    --
    local map = tools.check_supported_maps(tc.state.map_name)

    actions = scouting.first_overlord(actions, map, tc)

    for id, u in pairs(tc.state.units_myself) do
        if tc:isworker(u.type) then
            if is_drone_scouting and fun.size(scouting_drones) == 1 then
                local eleven = scouting.eleven_drone_scout(scouting_drones, id, u, actions, tc)
                actions = eleven["actions"]
                scouting_drones = eleven["scouting_drones"]
                is_drone_scouting = false           
            elseif is_drone_scouting and scouting_drones[1]['id'] ~= id then
                actions = openings.twelve_pool(id, u, actions, tc)
                is_drone_scouting = false
            elseif is_drone_expanding and scouting_drones[1]['id'] ~= id
                and fun.size(expansions) == 1 then
                actions = economy.take_natural(id, u, actions, tc)
                is_drone_expanding = false
            elseif fun.size(expansions) == 1 and expansions[1]['id'] == id
                and tc.state.resources_myself.ore >= 300 then
                actions = economy.build_natural(id, u, actions, tc)
            elseif fun.size(expansions) == 1
                and units['spawning']['extractors'][1] == nil
                and expansions[1]['id'] ~= id
                and scouting_drones[1]['id'] ~= id
                and tc.state.resources_myself.ore >= 42 then
                actions = economy.take_main_geyser(id, u, actions, tc)
            elseif units['spawning']['extractors'][1] ~= nil
                and fun.size(units['buildings']['extractors']) ~= 1
                and tc.state.resources_myself.ore >= 50 then
                actions = economy.build_main_extractor(units['spawning']['extractors'][1]['id'], u, actions, tc)
            -- Sending drones to extractor
            elseif drones_to_gas
                and expansions[1]['id'] ~= id
                and scouting_drones[1]['id'] ~= id
                and vespene_drones[3] == nil then
                if fun.size(vespene_drones) == 0 then
                    vespene_drones[1] = {["id"]=id}
                    -- clean and reformat this into its own function
                    table.insert(actions,
                    tc.command(tc.command_unit_protected, id,
                    tc.cmd.Right_Click_Unit, units['buildings']['extractors'][1]))
                elseif fun.size(vespene_drones) == 1 and vespene_drones[1]["id"] ~= id then
                    vespene_drones[2] = {["id"]=id}
                    table.insert(actions,
                    tc.command(tc.command_unit_protected, id,
                    tc.cmd.Right_Click_Unit, units['buildings']['extractors'][1]))
                elseif fun.size(vespene_drones) == 2 and vespene_drones[2]["id"] ~= id then
                    vespene_drones[3] = {["id"]=id}
                    table.insert(actions,
                    tc.command(tc.command_unit_protected, id,
                    tc.cmd.Right_Click_Unit, units['buildings']['extractors'][1]))
                end
            else
                units = economy.check_workers()
                if fun.find(units['busy'], id) == nil and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Gather])
                    and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                   and not utils.is_in(u.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
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
            units = economy.check_workers()
        end
    end
    print(inspect(units['busy']))
    -- First created overlord, second in total.. this is the 'overpool' overlord.
    if fun.size(units['drones']) == 9 and fun.size(units['overlords']) == 1
        and fun.size(is_spawning_overlord) == 0 and spawning_overlord == false then
        spawning_overlord = true
    end
    -- Scouting at 11
    if fun.size(units['drones']) == 10 and scouting_drones[1] == nil then
        scouting_drones[1] = {}
        is_drone_scouting = true
    end
    -- Spawning at 12 <---------------------- YOU ARE HERE
    if fun.size(units['drones']) == 12 and scouting_drones[2] == nil then
        scouting_drones[2] = {}
        is_drone_scouting = true
    end
    -- at 11 taking natural after '12pool'
    if fun.size(units['drones']) == 12 and fun.size(scouting_drones) == 2
        and expansions[1] == nil then
        expansions[1] = {}
        is_drone_expanding = true
    end
    -- at 16 building the third overlord
    if fun.size(units['drones']) >= 16 and fun.size(units['overlords']) == 2
        and spawning_overlord == false then
        spawning_overlord = true
    end
    -- stop drone powering at 12 focus change to 3th expansion and gas
    if fun.size(units['drones']) == 12 then
        powering = false
    elseif fun.size(units['drones']) < 12 then
        powering = true
    end
    -- gg
    return actions
end

function economy.manage_9734_macro(actions, tc)
    --
    -- ZvP 9734 simcity management
    --
    for id, u in pairs(tc.state.units_myself) do
        if tc:isbuilding(u.type) then
            -- (!)
            if u.type == tc.unittypes.Zerg_Spawning_Pool then
                tools.pass()
            end
            if u.type == tc.unittypes.Zerg_Spawning_Pool and u.flags.completed == true then
                tools.pass()
            end
            if u.type == tc.unittypes.Zerg_Extractor and u.flags.completed == true then
                --
                drones_to_gas = true
            end
            -- (!!)
           if u.type == tc.unittypes.Zerg_Hydralisk_Den then
                tools.pass()
            end
            if u.type == tc.unittypes.Zerg_Hydralisk_Den and u.flags.completed == true then
                tools.pass()
            end
            if u.type == tc.unittypes.Zerg_Hatchery then
                -- Spawning second overlord
                if spawning_overlord == true and fun.size(units['overlords']) == 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[2] = true
                end
                -- Spawn exactly 2 lings (;
                if spawning_lings == false
                    and fun.size(units['drones']) == 12
                    and fun.size(units['eggs']) < 1
                    and fun.size(units['lings']) == 0 then
                    spawning_lings = true
                end
                -- Spawning first lings
                if spawning_lings == true and fun.size(units['eggs']) ~= 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Zergling))
                    spawning_lings = false
                end
                -- Spwning first hydras
                if spawning_hydras == false
                    and fun.size(units['drones']) >= 22
                    and fun.size(units['eggs']) < 1
                    and fun.size(units['hydras']) == 0 then
                    spawning_hydras = true
                end
                if spawning_hydras == true and fun.size(units['eggs']) ~= 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Hydralisk))
                    if fun.size(units['hydras']) >= 12 then
                        spawning_hydras = false
                    end
                end
                -- Same for third overlord
                if spawning_overlord == true and fun.size(units['overlords']) == 2 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[3] = true
                end
                -- it appears that counting eggs was not that bad after all
                if spawning_overlord == false and fun.size(is_spawning_overlord) == 1 then
                    if fun.size(units["overlords"]) == 1 and fun.size(units["eggs"]) < 1 then
                        is_spawning_overlord[2] = nil
                        spawning_overlord = true
                    end
                end
                -- Old count eggs base style
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

function economy.manage_5hh_macro(actions, tc)
    --
    -- Standard ZvP 5HH simcity management
    --
    return actions
end

function economy.manage_2hm_macro(actions, tc)
    --
    -- Standard ZvT 2HM simcity management
    --
    return actions
end

function economy.manage_10p_macro(actions, tc)
    --
    -- ZvZ 10P simcity management
    --
    return actions
end

function economy.manage_12p_macro(actions, tc)
    --
    -- 12P simcity management
    --
    for id, u in pairs(tc.state.units_myself) do
        if tc:isbuilding(u.type) then
            -- (!)
            if u.type == tc.unittypes.Zerg_Spawning_Pool then
                tools.pass()
            end
            if u.type == tc.unittypes.Zerg_Spawning_Pool and u.flags.completed == true then
                tools.pass()
            end
            if u.type == tc.unittypes.Zerg_Extractor and u.flags.completed == true then
                --
                drones_to_gas = true
            end
            if u.type == tc.unittypes.Zerg_Hatchery then
                -- Spawning second overlord
                if spawning_overlord == true 
                    and fun.size(units['overlords']) == 1 
                    and fun.size(units['eggs']) < 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[2] = true
                end
                -- Spawn exactly 12 lings (;
                if spawning_lings == false
                    and fun.size(units['drones']) == 12
                    and fun.size(units['eggs']) < 1
                    and fun.size(units['lings']) < 12 then
                    spawning_lings = true
                end
                -- Spawning first lings
                if spawning_lings == true and fun.size(units['eggs']) ~= 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Train,
                    0,0,0, tc.unittypes.Zerg_Zergling))
                    spawning_lings = false
                    -- the following command change the rally point
                    table.insert(actions,
                    tc.command(tc.command_unit, id, tc.cmd.Right_Click_Position,
                    -1, quadrants[quadrant]["natural"]["x"],
                    quadrants[quadrant]["natural"]["y"]))
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

function economy.manage_game_economy(actions, enemy, resources, tc)
    --
    -- computer manage game economy
    --
    quadrant = scouting.base_quadrant()
    quadrants = scouting.all_quadrants()
    -- check my units
    units = economy.check_my_units(tc)
    -- check my geysers
    local geysers = economy.check_my_geysers(tc)
    -- geysers are fun, we can run with this until middle game!
    if fun.size(geysers) <= 2 and fun.size(units['geysers']) ~= 2 then
        if fun.size(geysers) == 1 then
            units['geysers'][1] = geysers[1]
        else
            -- this hack only support your main and natural geysers
            -- backtrack and continue when you MUST place that 3th gas!
            if units['geysers'][1] ~= geysers[1] then
                units['geysers'][2] = geysers[1]
            else
                units['geysers'][2] = geysers[2]
            end
        end
    end
    -- Set your units into 3 groups, collapse each on
    -- different sides of the enemy for maximum effectiveness.
    local offence = {}
    units['offence'] = offence
    -- Defense powerful but immobile, offence mobile but weak
    local defence = {}
    units['defence'] = defence
    -- Scout identify enemy units
    local enemy_units = scouting.identify_enemy_units(tc)
    units['enemy'] = enemy_units
    -- And Now For Something Completely Different
    if enemy['race'] == 0 then
        -- Ophelia vs Zerg: one way could be start with 12p
        -- 1. it's the build that soft counters early 9p preassure.
        -- 2. it's a zerg vs zerg bo but we could open like that vs random players
        -- 3. the work on the build is also usefull on the terran match up.
        actions = economy.manage_12p_bo(actions, tc)
        actions = economy.manage_12p_macro(actions, tc)
        
        -- NOTE: Yo, do not start working on multiple builds untill 
        -- testing results of the first ones against other bots.

        -- NOTE: are you sure you are ready know?
        -- call random BO, watch the results and make a future.

        --actions = economy.manage_12h_bo(actions, tc)
        --actions = economy.manage_12h_macro(actions, tc)
        --actions = economy.manage_9p_bo(actions, tc)
        --actions = economy.manage_9p_macro(actions, tc)
        --actions = economy.manage_9g_bo(actions, tc)
        --actions = economy.manage_9g_macro(actions, tc)
        --actions = economy.manage_10p_bo(actions, tc)
        --actions = economy.manage_10p_macro(actions, tc)
    elseif enemy['race'] == 1 then
        -- Ophelia vs Terran: start trying to not die vs bio and learning to use mutalisk
        -- the MU later branch into 3 main terran plays: bio, 1:1:1, or mech.
        actions = economy.manage_2hm_bo(actions, tc)
        actions = economy.manage_2hm_macro(actions, tc)
    elseif enemy['race'] == 2 then
        -- Ophelia Vs Protoss: Have enough drones with 6 hatches and 3 gas mining!
        actions = economy.manage_9734_bo(actions, tc)
        actions = economy.manage_9734_macro(actions, tc)
        -- since the original 9734 pony is not 'standard'
        --actions = economy.manage_5hh_bo(actions, tc)
        --actions = economy.manage_5hh_macro(actions, tc)
    else
        -- random
        actions = economy.manage_12p_bo(actions, tc)
        actions = economy.manage_12p_macro(actions, tc)
    end
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
    print("hatcheries " .. fun.size(units['buildings']['hatcheries']))
    print("spawning_pool " .. fun.size(units['buildings']['spawning_pool']))
    print("extractors " .. fun.size(units['buildings']['extractors']))
    print("evolution_chambers " .. fun.size(units['buildings']['evolution_chambers']))
    print("hydralisk_den " .. fun.size(units['buildings']['hydralisk_den']))
    print("lair " .. fun.size(units['buildings']['lair']))
    print("spire " .. fun.size(units['buildings']['spire']))
    print("creep_colonies " .. fun.size(units['buildings']['creep_colonies']))
    print("sunken_colonies " .. fun.size(units['buildings']['sunken_colonies']))
    print("spore_colonies " .. fun.size(units['buildings']['spore_colonies']))
    -- So long and thanks for all the fish!
    return actions
end

return economy
