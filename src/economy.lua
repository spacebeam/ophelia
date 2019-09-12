--
-- Ugly 9734 economy hack for now since we are just testing stuff
-- it needs more than a couple of good'old clean, clean, clean.
--

local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")
local scouting = require("ophelia.scouting") 

local economy = {}

local colonies = {}

local powering = true

local spawning_overlord = false

local is_spawning_overlord = {} 

local is_drone_scouting = false

local is_drone_expanding = false

local units = {}

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

local has_queen_nest = false

local has_defiler_mound = false

local has_ultralisk_cavern = false

local has_command_center = false

local scouting_overlords = {}

local scouting_drones = {}

-- Early, Make/defend a play & send colonies to one or two bases.
local early_stage = true
-- Middle, Core units, make/defend pressure & take a base.
local middle_stage = false
-- Late, Matured core units, multi-pronged tactics & take many bases.
local late_stage = false
-- Final, The watcher observes, the fog collapses an event resolves.
local final_stage = false


function economy.take_natural(colonies, uid, ut, actions, tc)
    -- take your natural
    local quadrant = scouting.base_quadrant()
    local quadrants = scouting.all_quadrants()
    if colonies[1]['sid'] == nil then colonies[1] = {["sid"]=uid} end
    if colonies[1]['sid'] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            --
            print(quadrant)
        elseif quadrant == 'B' then
            --
            print(quadrant)
        elseif quadrant == 'C' then
            --
            print(quadrant)
        elseif quadrant == 'D' then
            --
            print(quadrant)
        else print('let it crash') end
    end
    return {["actions"]=actions,["colonies"]=colonies}
end

function economy.take_third(colonies, uid, ut, actions, tc)
    -- take 3th expansion
    if colonies[3]['sid'] == nil then colonies[2] = {["sid"]=uid} end
    if colonies[3]['sid'] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            --
        elseif quadrant == 'B' then
            --
        elseif quadrant == 'C' then
            --
        elseif quadrant == 'D' then
            --
        else print('let it crash') end
    end
    return {["actions"]=actions,["colonies"]=colonies}
end

function economy.take_fourth(colonies, uid, ut, actions, tc)
    -- take 4th expansion
    if colonies[4]['sid'] == nil then colonies[2] = {["sid"]=uid} end
    if colonies[4]['sid'] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            --
        elseif quadrant == 'B' then
            --
        elseif quadrant == 'C' then
            --
        elseif quadrant == 'D' then
            --
        else print('let it crash') end
    end
    return {["actions"]=actions,["colonies"]=colonies}
end


-- !(?)

function economy.take_fifth()
    -- take 5th expansion
end

function economy.take_sixth()
    -- take 6th expansion
end

function economy.take_seventh()
    -- take 7th expansion
end

function economy.take_eighth()
    -- take 8th expansion
end

function economy.take_all()
    -- take it all
end

-- !(?)


function economy.manage_economy(actions, tc)

    -- What exactly is macro, anyway? 
    -- this interpretation includes 'powering'.
    -- powering is when computer switch to primarily
    -- economics, making drones and new extractors.
 
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

    -- Set your units into 4 groups, collapse each on
    -- different sides of the enemy for maximum effectiveness.
    local offence = {}
    -- Defense powerful but immobile, offence mobile but weak
    local defence = {}
    
    for uid, ut in pairs(tc.state.units_myself) do
        if ut.type == tc.unittypes.Zerg_Overlord then
            table.insert(overlords, uid)
            local _, pos = next(tc:filter_type(tc.state.units_myself, 
                {tc.unittypes.Zerg_Hatchery}))
            actions = scouting.first_overlord(pos, uid, ut, actions, tc)

            -- missing filter by overlord uid

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
        elseif ut.type == tc.unittypes.Zerg_Guardian then
            table.insert(guardians, uid)
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

            elseif is_drone_expanding and fun.size(colonies) == 1 then
                local expansion = economy.take_natural(colonies, uid, ut, actions, tc)
                actions = expansion["actions"]
                colonies = expansion["colonies"]
                is_drone_expanding = false

            elseif tc.state.resources_myself.ore >= 1600 then
                -- explore all sectors!
                actions = scouting.explore_all_sectors(scouting_drone, uid, ut, actions, tc)
            
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
    units["guardians"] = guardians
    units["infesteds"] = infesteds

    if fun.size(drones) == 9 and fun.size(overlords) == 1 
        and fun.size(is_spawning_overlord) == 0 and spawning_overlord == false then
        spawning_overlord = true
    end

    if fun.size(drones) == 11 and scouting_drones[1] == nil then
        scouting_drones[1] = {}
        is_drone_scouting = true
    end
    
    if fun.size(drones) == 12 and scouting_drones[2] == nil then
        scouting_drones[2] = {}
        is_drone_scouting = true
    end
    
    if fun.size(drones) == 12 and scouting_drones[2] ~= nil 
        and colonies[1] == nil then
        colonies[1] = {}
        is_drone_expanding = true
    end

    if fun.size(drones) == 16 and fun.size(overlords) == 2 
        and spawning_overlord == false then
        spawning_overlord = true
    end
    
    if fun.size(drones) >= 19 then
        powering = false
    else powering = true end
    
    print("overlords " .. fun.size(overlords))
    print("larvae ".. fun.size(larvae))
    print("eggs " .. fun.size(eggs))
    print("drones " .. fun.size(drones))
    print("lings " .. fun.size(lings))
    print("hydras " .. fun.size(hydras))
    print("lurkers " .. fun.size(lurkers))
    print("mutas " .. fun.size(mutas))
    print("scourges " .. fun.size(scourges))
    print("queens " .. fun.size(queens))
    print("defilers " .. fun.size(defilers))
    print("ultras " .. fun.size(ultras))
    print("guardians " .. fun.size(guardians))
    
    -- So long and thanks for all the fish!
    return actions
end

return economy
