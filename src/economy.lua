--
-- Ugly 9734 hack for now since we are just testing stuff
-- it needs more than a couple of good'old clean, clean, clean.
--

local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")

local economy = {}

local quadrants = {}
quadrants["A"] = {}
quadrants["B"] = {}
quadrants["C"] = {}
quadrants["D"] = {}

local powering = true

local spawning_overlord = false

local is_spawning_overlord = {} 

local units = {}

local spawning_pool = 0 

local extractor = 0

local evolution_chamber = 0 

local hydralisk_den = 0

local spire = 0 

local queen_nest = 0 

local defiler_mound = 0 

local command_center = 0

local ultralisk_cavern = 0

local has_spawning_pool = false

local has_evolution_chamber = false

local has_hydralisk_den = false

local has_spire = false

local has_queen_nest = false

local has_defiler_mound = false

local has_ultralisk_cavern = false

local has_command_center = false


local chambers = {}
chambers[1] = nil
chambers[2] = nil
chambers[3] = nil

-- Early, Make/defend a play & send colonies to one or two bases.
local early_stage = true
-- Middle, Core units, make/defend pressure & take a base.
local middle_stage = false
-- Late, Matured core units, multi-pronged tactics & take many bases.
local late_stage = false
-- Final, The watcher observes, the fog collapses an event resolves.
local final_stage = false

function economy.manage_economy(actions, tc)

    -- What exactly is macro, anyway? 
    -- this interpretation includes 'powering'.
    -- powering is when computer switch to primarily
    -- economics, making drones and new gas patches.
 
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

    local infesteds = {}

    local overlords = {}

    -- Swarm colonies 
    local colonies = {}
    colonies[1] = 0
    colonies[2] = 0
    colonies[3] = 0
    colonies[4] = 0
    colonies[5] = 0
    colonies[6] = 0
    colonies[7] = 0
    colonies[8] = 0
    colonies[9] = 0
    colonies[10] = 0
    colonies[11] = 0
    colonies[12] = 0
    colonies[13] = 0
    colonies[14] = 0
    colonies[15] = 0
    colonies[16] = 0
    
    -- Blueberry haze 
    local extractors = {}
    extractors[1] = 0
    extractors[2] = 0
    extractors[3] = 0
    extractors[4] = 0
    extractors[5] = 0
    extractors[6] = 0
    extractors[7] = 0
    extractors[8] = 0
    extractors[9] = 0
    extractors[10] = 0
    extractors[11] = 0
    extractors[12] = 0
    
    -- Swarm rallypoints
    local rallypoints = {}
    rallypoints[1] = 0
    rallypoints[2] = 0
    rallypoints[3] = 0
    rallypoints[4] = 0
    rallypoints[5] = 0
    rallypoints[6] = 0
    rallypoints[7] = 0
    rallypoints[8] = 0
    
    -- !
    local buildings = {}

    -- Set your units into 4 groups, collapse each on
    -- different sides of the enemy for maximum effectiveness.
    local offence = {}
    -- Defense powerful but immobile, offence mobile but weak
    local defence = {}
    
    for uid, ut in pairs(tc.state.units_myself) do
        if ut.type == tc.unittypes.Zerg_Overlord then
            table.insert(overlords, uid)

            -- init test with scouting quadrants
            local _, pos = next(tc:filter_type(tc.state.units_myself, 
                {tc.unittypes.Zerg_Hatchery}))

            if pos ~= nil then pos = pos.position end

            if pos ~= nil then 
                print('starting location: x '..pos[1] .. ' y ' .. pos[2])
            end

        elseif ut.type == tc.unittypes.Zerg_Zergling then
            table.insert(lings, uid)
        elseif ut.type == tc.unittypes.Zerg_Hydralisk then
            table.insert(hydras, uid)
        elseif ut.type == tc.unittypes.Zerg_Mutalisk then
            table.insert(mutas, uid)
        elseif ut.type == tc.unittypes.Zerg_Lurker then
            table.insert(lurkers, uid)
        elseif ut.type == tc.unittypes.Zerg_Queen then
            table.insert(queens, uid)
        elseif ut.type == tc.unittypes.Zerg_Defiler then
            table.insert(defilers, uid)
        elseif ut.type == tc.unittypes.Zerg_Egg then
            table.insert(eggs, uid)
        elseif ut.type == tc.unittypes.Zerg_Larva then
            table.insert(larvae, uid)
        elseif ut.type == tc.unittypes.Zerg_Scourge then
            table.insert(scourges, uid)
        elseif ut.type == tc.unittypes.Zerg_Ultralisk then
            table.insert(ultras, uid)
        elseif ut.type == tc.unittypes.Zerg_Infested_Terran then
            table.insert(infesteds, uid)
        elseif tc:isworker(ut.type) then        
            table.insert(drones, uid)
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

            elseif tc.state.resources_myself.ore >= 300 
                and tc.state.frame_from_bwapi - colonies[1] > 200 then
                colonies[1] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    56, 152))
                end

            elseif tc.state.resources_myself.ore >= 300 
                and tc.state.frame_from_bwapi - colonies[2] > 200 then
                colonies[2] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    36, 470))
                end

            elseif tc.state.resources_myself.ore >= 300 
                and tc.state.frame_from_bwapi - colonies[3] > 200 then
                colonies[3] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    476, 474))
                end

            elseif tc.state.resources_myself.ore >= 300 
                and tc.state.frame_from_bwapi - colonies[4] > 200 then
                colonies[4] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    476, 34))
                end

            elseif tc.state.resources_myself.ore >= 300 
                and tc.state.frame_from_bwapi - colonies[5] > 200 then
                colonies[5] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    156, 460))
                end

            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[6] > 200 then
                colonies[6] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    456, 350))
                end

            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[7] > 200 then
                colonies[7] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    350, 50))
                end
            
            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[8] > 200 then
                colonies[8] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    35, 35))
                end
            
            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[9] > 200 then
                colonies[9] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    216, 20))
                end
            
            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[10] > 200 then
                colonies[10] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    30, 290))
                end
            
            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[11] > 200 then
                colonies[11] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    490, 220))
                end

            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[12] > 200 then
                colonies[12] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    256, 256))
                end
            
            elseif tc.state.resources_myself.ore >= 500 
                and tc.state.frame_from_bwapi - colonies[13] > 200 then
                colonies[13] = tc.state.frame_from_bwapi
                if not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Build])
                    and not utils.is_in(ut.order,
                    tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid,
                    tc.cmd.Move, -1,
                    315, 490))
                end
            else
                -- tests gathering
                if not utils.is_in(ut.order,
                      tc.command2order[tc.unitcommandtypes.Gather])
                      and not utils.is_in(ut.order,
                      tc.command2order[tc.unitcommandtypes.Build])
                      and not utils.is_in(ut.order,
                      tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
                    -- avoid spamming the order is the unit is already
                    -- following the right order or building!
                    -- currently we need to learn how to get vespene gas
                    local target = tools.get_closest(ut.position,
                        tc:filter_type(tc.state.units_neutral,
                            {tc.unittypes.Resource_Mineral_Field,
                             tc.unittypes.Resource_Mineral_Field_Type_1,
                             tc.unittypes.Resource_Mineral_Field_Type_3,
                             tc.unittypes.Resource_Mineral_Field_Type_2,
                             tc.unittypes.Resorce_Mineral_Field_Type_5,
                             tc.unittypes.Resorce_Mineral_Field_Type_4,}))
                    if target ~= nil then
                        table.insert(actions,
                        tc.command(tc.command_unit_protected, uid,
                        tc.cmd.Right_Click_Unit, target))
                    end
                end
            end
        elseif tc:isbuilding(ut.type) then
            -- tests stuff within buildings: train, upgrade, rally!
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
                if powering == true then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Drone))
                end
            end
        else
            -- attacks closest
            local target = tools.get_closest(ut.position,
                                       tc.state.units_enemy)
            if target ~= nil then
                table.insert(actions,
                tc.command(tc.command_unit_protected, uid,
                tc.cmd.Attack_Unit, target))
            end
        end
    end

    -- !! 
    
    units["larvae"] = larvae
    units["eggs"] = eggs
    units["drones"] = drones
    units["overlords"] = overlords
    units["lings"] = lings
    units["hydras"] = hydras
    units["mutas"] = mutas
    units["queens"] = queens
    units["defilers"] = defilers
    units["scourges"] = scourges
    units["ultras"] = ultras
    units["infesteds"] = infesteds

    for k, v in pairs(is_spawning_overlord) do
        print(k, v)
    end

    if fun.size(drones) == 9 and fun.size(overlords) == 1 and fun.size(is_spawning_overlord) == 0 and spawning_overlord == false then
        spawning_overlord = true
    end
    
    if fun.size(drones) == 17 and fun.size(overlords) == 2 and spawning_overlord == false then
        spawning_overlord = true
    end
    
    if fun.size(drones) >= 19 then
        powering = false
    else
        powering = true
    end
    
    print(powering)
    print(spawning_overlord)
    print("larvae ".. fun.size(larvae))
    print("eggs " .. fun.size(eggs))
    print("drones " .. fun.size(drones))
    print("overlords " .. fun.size(overlords))
    print("lings " .. fun.size(lings))
    print("hydras " .. fun.size(hydras))
    print("lurkers " .. fun.size(lurkers))
    print("mutas " .. fun.size(mutas))
    print("scourges " .. fun.size(scourges))
    print("queens " .. fun.size(queens))
    print("defilers " .. fun.size(defilers))
    print("ultras " .. fun.size(ultras))
    print(fun.size(is_spawning_overlord))

    -- So long and thanks for all the fish!
    return actions
end

return economy
