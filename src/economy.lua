--
-- Ugly 9734 economy hack for now since we are just testing stuff
-- it needs more than a couple of good'old clean, clean, clean.
--

local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")
local scouting = require("ophelia.scouting") 

local economy = {}

local powering = true

local units = {["busy"]={},["idle"]={}}

local hatcheries = {}

local is_drone_scouting = false

local is_drone_expanding = false

local spawning_overlord = false

local spawning_lings = false

local spawning_hydras = false

local is_spawning_overlord = {}

local is_spawning_lings = {}

local is_spawning_hydras = {}

local spawning_pool = 0 

local extractor = 0

local evolution_chamber = 0 

local hydralisk_den = 0

local spire = 0 

local queens_nest = 0 

local defiler_mound = 0 

local command_center = 0

local ultralisk_cavern = 0

local has_spawning_pool = false

local has_evolution_chamber = false

local has_hydralisk_den = false

local has_spire = false

local has_greater_spire = false

local has_queens_nest = false

local has_defiler_mound = false

local has_ultralisk_cavern = false

local has_command_center = false

-- !?, !?, !?

local scouting_overlords = {}

local scouting_drones = {}

local scouting_lings = {}

-- Early, Make/defend a play & send colonies to one or two bases.
local early_stage = true
-- Middle, Core units, make/defend pressure & take a base.
local middle_stage = false
-- Late, Matured core units, multi-pronged tactics & take many bases.
local late_stage = false
-- Final, The watcher observes, the fog collapses an event resolves.
local final_stage = false

function economy.check_workers(units, hatcheries, scouting_drones)
    local busy = {}
    for _, v in ipairs(hatcheries) do
        if v['sid'] ~= nil then table.insert(busy, v['sid']) end
    end
    for _, v in ipairs(scouting_drones) do
        if v['uid'] ~= nil then table.insert(busy, v['uid']) end
    end
    units['busy'] = busy
    return units
end

function economy.check_my_units(units, tc)
    local overlords = {}
    local larvae = {}
    local eggs = {}
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
    local infesteds = {}
    for uid, ut in pairs(tc.state.units_myself) do
        if ut.type == tc.unittypes.Zerg_Overlord then
            table.insert(overlords, uid)
        elseif ut.type == tc.unittypes.Zerg_Zergling then
            table.insert(lings, uid)
        elseif ut.type == tc.unittypes.Zerg_Drone then
            table.insert(drones, uid)
        elseif ut.type == tc.unittypes.Zerg_Larva then
            table.insert(larvae, uid)
        elseif ut.type == tc.unittypes.Zerg_Egg then
            table.insert(eggs, uid)
        elseif ut.type == tc.unittypes.Zerg_Hydralisk then
            table.insert(hydras, uid)
        elseif ut.type == tc.unittypes.Zerg_Mutalisk then
            table.insert(mutas, uid)
        elseif ut.type == tc.unittypes.Zerg_Scourge then
            table.insert(scourges, uid)
        elseif ut.type == tc.unittypes.Zerg_Lurker then
            table.insert(lurkers, uid)
        elseif ut.type == tc.unittypes.Zerg_Queen then
            table.insert(queens, uid)
        elseif ut.type == tc.unittypes.Zerg_Defiler then
            table.insert(defilers, uid)
        elseif ut.type == tc.unittypes.Zerg_Ultralisk then
            table.insert(ultras, uid)
        elseif ut.type == tc.unittypes.Zerg_Guardian then
            table.insert(guardians, uid)
        elseif ut.type == tc.unittypes.Zerg_Infested_Terran then
            table.insert(infesteds, uid)
        else
            -- do nothing, ignore unit type
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
    units["infesteds"] = infesteds
    return units
end

function economy.take_natural(hatcheries, uid, ut, actions, tc)
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if hatcheries[1]['sid'] == nil then hatcheries[1] = {["sid"]=uid} end
    if hatcheries[1]['sid'] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"]))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"]))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["C"]["natural"]["x"], quadrants["C"]["natural"]["y"]))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"]))
        else print('economy.take_natural crash') end
    end
    return {["actions"]=actions,["hatcheries"]=hatcheries}
end

function economy.build_natural(hatcheries, uid, ut, actions, tc)
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["C"]["natural"]["x"], quadrants["C"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        else print('economy.build_natural crash') end
    end
    return {["actions"]=actions,["hatcheries"]=hatcheries}
end

function economy.take_third(hatcheries, uid, ut, actions, tc)
    -- NOTE; you can't place this without scouting your enemy's position!
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if hatcheries[2]['sid'] == nil then hatcheries[2] = {["sid"]=uid} end
    if hatcheries[2]['sid'] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"]))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"]))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"]))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants["C"]["natural"]["x"], quadrants["C"]["natural"]["y"]))
        else print('economy.take_third crash') end
    end
    return {["actions"]=actions,["hatcheries"]=hatcheries}
end

function economy.build_third(hatcheries, uid, ut, actions, tc)
   
    -- Water machine build your third base

    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    
    -- where is enemy's start location?
    
    if not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["B"]["natural"]["x"], quadrants["B"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["A"]["natural"]["x"], quadrants["A"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Build, -1,
            quadrants["D"]["natural"]["x"], quadrants["D"]["natural"]["y"],
            tc.unittypes.Zerg_Hatchery))
        else print('economy.build_third crash') end
    end
    return {["actions"]=actions,["hatcheries"]=hatcheries}
end

function economy.take_fourth(hatcheries, uid, ut, actions, tc)
    -- NOTE, location of 4th base depends on 3th.
end

function economy.take_fifth()
    -- NOTE, wait until you have darkswarm!
end


-- !(?)

function economy.take_it_all()
    -- take it all
end

-- !(?)


function economy.manage_9734_workers(actions, tc)
    -- 9734 worker management 
end

function economy.manage_9734_simcity(actions, tc)
    -- 9734 simcity management
end


-- O=


function economy.manage_9734_economy(actions, tc)

    -- What exactly is macro, anyway? 
    -- this interpretation includes 'powering'.
    -- powering is when computer switch to primarily
    -- economics, making drones and new extractors.
 
    local units = economy.check_my_units(units, tc)

    -- Set your units into 3 groups, collapse each on
    -- different sides of the enemy for maximum effectiveness.
    local offence = {}
    -- Defense powerful but immobile, offence mobile but weak
    local defence = {}

    local enemy = scouting.identify_enemy_units(tc.state.units_enemy, tc)

    for uid, ut in pairs(tc.state.units_myself) do
        if tc:isworker(ut.type) then        
            if has_spawning_pool == false and tc.state.resources_myself.ore >= 200
                and tc.state.frame_from_bwapi - spawning_pool > 190 then
                -- tests your spawning pool        
                spawning_pool = tc.state.frame_from_bwapi
                local _, pos = next(tc:filter_type(
                tc.state.units_myself,
                {tc.unittypes.Zerg_Hatchery}))
                if pos ~= nil then pos = pos.position end
                if pos ~= nil and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Build, -1,
                    pos[1], pos[2] + 16, tc.unittypes.Zerg_Spawning_Pool))
                end
            elseif is_drone_scouting and fun.size(scouting_drones) == 1 then
                local eleven = scouting.eleven_drone_scout(scouting_drones, uid, ut, actions, tc)
                actions = eleven["actions"]
                scouting_drones = eleven["scouting_drones"]
                is_drone_scouting = false
            elseif is_drone_scouting and scouting_drones[1]['uid'] ~= uid then
                local twelve = scouting.twelve_drone_scout(scouting_drones, uid, ut, actions, tc)
                actions = twelve["actions"]
                scouting_drones = twelve["scouting_drones"]
                is_drone_scouting = false
            elseif is_drone_expanding and scouting_drones[1]['uid'] ~= uid 
                and scouting_drones[2]['uid'] ~= uid and fun.size(hatcheries) == 1 then
                local expansion = economy.take_natural(hatcheries, uid, ut, actions, tc)
                actions = expansion["actions"]
                hatcheries = expansion["hatcheries"]
                is_drone_expanding = false
            elseif fun.size(hatcheries) == 1 and hatcheries[1]['sid'] == uid 
                and tc.state.resources_myself.ore >= 200 then
                local expansion = economy.build_natural(hatcheries, uid, ut, actions, tc)
                actions = expansion["actions"]
                hatcheries = expansion["hatcheries"]
            elseif is_drone_expanding and scouting_drones[2]['uid'] == uid 
                and fun.size(hatcheries) == 2 then
                local expansion = economy.take_third(hatcheries, uid, ut, actions, tc)
                actions = expansion["actions"]
                hatcheries = expansion["hatcheries"]
                is_drone_expanding = false
                print('move ' .. uid)
            elseif fun.size(hatcheries) == 2 and hatcheries[2]['sid'] == uid 
                and tc.state.resources_myself.ore >= 300 then
                local expansion = economy.build_third(hatcheries, uid, ut, actions, tc)
                actions = expansion["actions"]
                hatcheries = expansion["hatcheries"]
                print('after economy.build_third ?')

                -- !?

            elseif tc.state.resources_myself.ore >= 1800 then
                -- drones explore all sectors!
                actions = scouting.explore_all_sectors(scouting_drones, uid, ut, actions, tc)
            else
                -- tests gathering, where is my missing gas?
                if fun.find(units['busy'], uid) == nil and not utils.is_in(ut.order,
                      tc.command2order[tc.unitcommandtypes.Gather])
                      and not utils.is_in(ut.order,
                      tc.command2order[tc.unitcommandtypes.Build])
                      and not utils.is_in(ut.order,
                      tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    -- currently we still need to learn how to get vespene gas!
                    local target = tools.get_closest(ut.position,
                        tc:filter_type(tc.state.units_neutral,
                            {tc.unittypes.Resource_Mineral_Field,
                             tc.unittypes.Resource_Mineral_Field_Type_3,
                             tc.unittypes.Resource_Mineral_Field_Type_2,}))
                    if target ~= nil then
                        table.insert(actions,
                        tc.command(tc.command_unit_protected, uid,
                        tc.cmd.Right_Click_Unit, target))
                    end
                end
            end
        elseif tc:isbuilding(ut.type) then
            if ut.type == tc.unittypes.Zerg_Spawning_Pool then
                if has_spawning_pool == false then
                    has_spawning_pool = true
                end
            end
            if ut.type == tc.unittypes.Zerg_Hatchery then
                if spawning_overlord == true and fun.size(is_spawning_overlord) == 0 then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[2] = true
                end
                if spawning_overlord == true and fun.size(is_spawning_overlord) == 1 then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                    is_spawning_overlord[3] = true
                end
                if spawning_overlord == true and fun.size(is_spawning_overlord) == 2 then
                    if fun.size(units["eggs"]) < 1 then
                        is_spawning_overlord[3] = nil
                    end
                end
                -- init test on spawning lings!
                if spawning_lings == true and fun.size(is_spawning_lings) == 0 then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Zergling))
                    spawning_lings = false
                    is_spawning_lings[2] = true
                end
                -- init test on spawning hydras! 
                if spawning_hydras == true and fun.size(is_spawning_hydras) == 0 then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Hydralisk))
                    spawning_hydras = false
                    is_spawning_hydras[1] = true
                end 
                if powering == true then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Drone))
                end
            end
        else
            -- dumb ai attacks closest
            local target = tools.get_closest(ut.position,
                                       tc.state.units_enemy)
            if target ~= nil then
                table.insert(actions,
                tc.command(tc.command_unit_protected, uid,
                tc.cmd.Attack_Unit, target))
            end
        end
    end

    units = economy.check_workers(units, hatcheries, scouting_drones)

    if fun.size(units['drones']) == 9 and fun.size(units['overlords']) == 1 
        and fun.size(is_spawning_overlord) == 0 and spawning_overlord == false then
        spawning_overlord = true
    end

    if fun.size(units['drones']) == 11 and scouting_drones[1] == nil then
        scouting_drones[1] = {}
        is_drone_scouting = true
    end
    
    if fun.size(units['drones']) == 12 and scouting_drones[2] == nil then
        scouting_drones[2] = {}
        is_drone_scouting = true
    end
    
    if fun.size(units['drones']) == 12 and scouting_drones[2] ~= nil 
        and hatcheries[1] == nil then
        hatcheries[1] = {}
        is_drone_expanding = true
    end

    if fun.size(units['drones']) == 12 and fun.size(units['lings']) == 0 
        and fun.size(is_spawning_lings) == 0 and spawning_lings == false then
        spawning_lings = true
    end

    if fun.size(units['drones']) == 13 and scouting_drones[2] ~= nil 
        and hatcheries[2] == nil then
        hatcheries[2] = {}
        is_drone_expanding = true
    end

    if fun.size(units['drones']) == 16 and fun.size(units['overlords']) == 2 
        and spawning_overlord == false then
        spawning_overlord = true
    end
    
    if fun.size(units['drones']) >= 19 then
        powering = false
    else powering = true end

    if fun.size(units['drones']) >= 12 then
        powering = false
    else powering = true end

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
    
    -- So long and thanks for all the fish!
    return actions
end

return economy
