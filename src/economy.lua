--
-- Ugly 9734 hack for now since we are just testing stuff
-- it needs more than a couple of good'old clean, clean, clean.
--
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")

local economy = {}

local powering = true

local spawning_overlord = false

local is_spawning_overlord = {} 

local spawning_pool = 0

local hydralisk_den = 0

local spire = 0

local has_spool = false

local has_hydraden = false

local has_evochamber = false

local has_spire = false

-- Evolution chambers
local evolution_chamber = 0
--
local chambers = {}
chambers[1] = 0
chambers[2] = 0
chambers[3] = 0

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
    local workers = {}
    -- Spawn more overlords!
    local overlords = {}
    -- swarm colonies 
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
    -- swarm rallypoint
    local rallypoints = {}
    rallypoints[1] = 0
    rallypoints[2] = 0
    rallypoints[3] = 0
    rallypoints[4] = 0
    rallypoints[5] = 0
    rallypoints[6] = 0
    rallypoints[7] = 0
    rallypoints[8] = 0
    -- Timing to expand is key and can be extracted
    -- from datasets of competitive players.
    local buildings = {}
    -- Set your units into 4 groups, collapse each on
    -- different sides of the enemy for maximum effectiveness.
    local offence = {}
    -- Defense powerful but immobile, offence mobile but weak
    local defence = {}
    
    for uid, ut in pairs(tc.state.units_myself) do
        if tc:isbuilding(ut.type) then
            -- tests stuff within buildings: train, upgrade, rally!
            if ut.type == tc.unittypes.Zerg_Spawning_Pool then
                if has_spool == false then
                    has_spool = true
                end
            end
            if ut.type == tc.unittypes.Zerg_Hatchery then
                if powering == true then
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Drone))
                end
                if spawning_overlord == true and is_spawning_overlord[#overlords+1] == nil then
                    print('lol wtf')
                    is_spawning_overlord[#overlords+1] = true
                    table.insert(actions,
                    tc.command(tc.command_unit, uid, tc.cmd.Train,
                    0, 0, 0, tc.unittypes.Zerg_Overlord))
                    spawning_overlord = false
                end
            end
        elseif ut.type == tc.unittypes.Zerg_Overlord then
            table.insert(overlords, uid)
        elseif tc:isworker(ut.type) then        
            table.insert(workers, uid)
            if has_spool == false and tc.state.resources_myself.ore >= 200
                and tc.state.frame_from_bwapi - spawning_pool > 190 then
                -- tests building        
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
                    print('starting location: x ' .. pos[1] .. ' y ' .. pos[2])
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
    -- 

    if #workers == 9 and #overlords == 1 and spawning_overlord == false then
        spawning_overlord = true
    end
    
    if #workers > 10 and #workers < 19 and powering == false then
        powering = true
    end
    
    if #workers == 16 and #overlords == 2 and powering == true and spawning_overlord == false then
        spawning_overlord = true
    end
    
    if #workers >= 19 then
        powering = false
    end

    -- So long and thanks for all the fish!
    return actions
end

return economy
