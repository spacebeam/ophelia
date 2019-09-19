--
-- Scouting overlords,
-- scouting drones,
-- scouting lings,
-- scouting scourges.
--

local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools") -- !??

-- one at 11 drone,
-- two at 12 drone, 200 mineral.
local scouting = {}

local enemy = {}
enemy["P"] = {["units"]={},["race"]="Protoss",["against"]=false}
enemy["Z"] = {["units"]={},["race"]="Zerg",["against"]=false}
enemy["T"] = {["units"]={},["race"]="Terran",["against"]=false}

local quadrant = nil
-- Map is not territory, but...
-- since handling 512x512 for all things.
local quadrants = {}
quadrants["A"] = {
    ["scout"] = {["x"]=450,["y"]=50},
    ["main"] = {["x"]=476,["y"]=34},
    ["natural"] = {["x"]=360,["y"]=60},
    ["third"] = {["x"]=490,["y"]=220},
    ["center"] = nil,
}
quadrants["B"] = {
    ["scout"] = {["x"]=50,["y"]=50},
    ["main"] = {["x"]=35,["y"]=35},
    ["natural"] = {["x"]=56,["y"]=152},
    ["third"] = {["x"]=216,["y"]=20},
    ["center"] = {["x"]=256,["y"]=256},
}
quadrants["C"] = {
    ["scout"] = {["x"]=50,["y"]=450},
    ["main"] = {["x"]=36,["y"]=470},
    ["natural"] = {["x"]=146,["y"]=448},
    ["third"] = {["x"]=30,["y"]=290},
    ["center"] = nil,
}
quadrants["D"] = {
    ["scout"] = {["x"]=450,["y"]=450},
    ["main"] = {["x"]=476,["y"]=474},
    ["natural"] = {["x"]=442,["y"]=356},
    ["third"] = {["x"]=315,["y"]=490},
    ["center"] = nil,
}
quadrants["A"][1] = 0
quadrants["A"][2] = 0
quadrants["A"][3] = 0
quadrants["A"][4] = 0
quadrants["B"][5] = 0
quadrants["B"][6] = 0
quadrants["B"][7] = 0
quadrants["B"][8] = 0
quadrants["C"][9] = 0
quadrants["C"][10] = 0
quadrants["C"][11] = 0
quadrants["C"][12] = 0
quadrants["D"][13] = 0
quadrants["D"][14] = 0
quadrants["D"][15] = 0
quadrants["D"][16] = 0

function scouting.identify_enemy_units(uid, ut, tc)
    -- Zerg things
    local overlords = {}
    local drones = {}
    local lings = {}
    local mutas = {}
    local scourges = {}
    local hacheries = {}
    local extractors = {}
    local spawning_pool = {}
    local evolution_chamber = {}
    local lair = {}
    local spire = {}
    -- Protoss stuffs
    local probes = {}
    local zealots = {}
    local dragoons = {}
    local archons = {}
    local dark_archons = {}
    local dark_templars = {}
    local high_templars = {}
    local reavers = {}
    local scarabs = {}
    local corsairs = {}
    local observers = {}
    local scouts = {}
    local shuttles = {}
    local nexus = {}
    local observatory = {}
    local robotics_facility = {}
    local robotics_support_bay = {}
    local pylons = {}
    local forge = {}
    local gateways = {}
    local assimilators = {}
    local cybernetics_core = {}
    local citadel_of_adun = {}
    local stargates = {}
    local templar_archives = {}
    -- Terran reasons
    local scvs = {}
    local command_centers = {}
    local supply_depots = {}
    local refineries = {}
    local barracks = {}
    local engineering_bay = {}
    local missile_turret = {}
    local academy = {}
    local armory = {}
    local factories = {}
    local science_facility = {}
    local starports = {}
    local bunkers = {}
    local firebats = {}
    local goliaths = {}
    local marines = {}
    local medics = {}
    local siege_tanks = {}
    local tanks = {}
    local vultures = {}
    local spider_mines = {}
    local battlecruisers = {}
    local dropships = {}
    local science_vessels = {}
    local valkyries = {}
    local wraiths = {}
    -- Awaken my child, and embrace the glory that is your birthright.
    if ut.type == tc.unittypes.Zerg_Overlord then
        table.insert(overlords, uid)
    elseif ut.type == tc.unittypes.Zerg_Drone then
        table.insert(drones, uid)
    elseif ut.type == tc.unittypes.Zerg_Zergling then
        table.insert(lings, uid)
    elseif ut.type == tc.unittypes.Zerg_Mutalisk then
        table.insert(mutas, uid)
    elseif ut.type == tc.unittypes.Zerg_Scourge then
        table.insert(scourges, uid)
    elseif ut.type == tc.unittypes.Zerg_Hatchery then
        table.insert(hatcheries, uid)
    elseif ut.type == tc.unittypes.Zerg_Extractor then
        table.insert(extractors, uid)
    elseif ut.type == tc.unittypes.Zerg_Spawning_Pool then
        table.insert(spawning_pool, uid)
    elseif ut.type == tc.unittypes.Zerg_Evolution_Chamber then
        table.insert(evolution_chamber, uid)
    elseif ut.type == tc.unittypes.Zerg_Lair then
        table.insert(lair, uid)
    elseif ut.type == tc.unittypes.Zerg_Spire then
        table.insert(spire, uid)
    -- Why give my life for Aiur?
    elseif ut.type == tc.unittypes.Protoss_Probe then
        table.insert(probes, uid)
    elseif ut.type == tc.unittypes.Protoss_Zealot then
        table.insert(zealots, uid)
    elseif ut.type == tc.unittypes.Protoss_Dragoon then
        table.insert(dragoons, uid)
    elseif ut.type == tc.unittypes.Protoss_Archon then
        table.insert(archons, uid)
    elseif ut.type == tc.unittypes.Protoss_Dark_Archon then
        table.insert(dark_archons, uid)
    elseif ut.type == tc.unittypes.Protoss_Dark_Templar then
        table.insert(dark_templars, uid)
    elseif ut.type == tc.unittypes.Protoss_High_Templar then
        table.insert(high_templars, uid)
    elseif ut.type == tc.unittypes.Protoss_Reaver then
        table.insert(reavers, uid)
    elseif ut.type == tc.unittypes.Protoss_Scarab then
        table.insert(scarabs, uid)
    elseif ut.type == tc.unittypes.Protoss_Corsair then
        table.insert(corsairs, uid)
    elseif ut.type == tc.unittypes.Protoss_Observer then
        table.insert(observers, uid)
    elseif ut.type == tc.unittypes.Protoss_Scout then
        table.insert(scouts, uid)
    elseif ut.type == tc.unittypes.Protoss_Shuttle then
        table.insert(shuttles, uid)
    elseif ut.type == tc.unittypes.Protoss_Nexus then
        table.insert(nexus, uid)
    elseif ut.type == tc.unittypes.Protoss_Observatory then
        table.insert(observatory, uid)
    elseif ut.type == tc.unittypes.Protoss_Robotics_Facility then
        table.insert(robotics_facility, uid)
    elseif ut.type == tc.unittypes.Protoss_Robotics_Support_Bay then
        table.insert(robotics_support_bay, uid)
    elseif ut.type == tc.unittypes.Protoss_Pylon then
        table.insert(pylons, uid)
    elseif ut.type == tc.unittypes.Protoss_Forge then
        table.insert(forge, uid)
    elseif ut.type == tc.unittypes.Protoss_Photon_Cannon then
        table.insert(cannons, uid)
    elseif ut.type == tc.unittypes.Protoss_Gateway then
        table.insert(gateways, uid)
    elseif ut.type == tc.unittypes.Protoss_Assimilator then
        table.insert(assimilators, uid)
    elseif ut.type == tc.unittypes.Protoss_Cybernetics_Core then
        table.insert(cybernetics_core, uid)
    elseif ut.type == tc.unittypes.Protoss_Citadel_of_Adun then
        table.insert(citadel_of_adun, uid)
    elseif ut.type == tc.unittypes.Protoss_Stargate then
        table.insert(stargates, uid)
    elseif ut.type == tc.unittypes.Protoss_Templar_Archives then
        table.insert(templar_archives, uid)
    -- God bless terran rednecks
    elseif ut.type == tc.unittypes.Terran_SCV then
        table.insert(scvs, uid)
    elseif ut.type == tc.unittypes.Terran_Command_Center then
        table.insert(command_centers, uid)
    elseif ut.type == tc.unittypes.Terran_Supply_Depot then
        table.insert(supply_depots, uid)
    elseif ut.type == tc.unittypes.Terran_Refinery then
        table.insert(refineries, uid)
    elseif ut.type == tc.unittypes.Terran_Barracks then
        table.insert(barracks, uid)
    elseif ut.type == tc.unittypes.Terran_Engineering_Bay then
        table.insert(engineering_bay, uid)
    elseif ut.type == tc.unittypes.Terran_Missile_Turret then
        table.insert(missile_turrets, uid)
    elseif ut.type == tc.unittypes.Terran_Academy then
        table.insert(academy, uid)
    elseif ut.type == tc.unittypes.Terran_Armory then
        table.insert(armory, uid)
    elseif ut.type == tc.unittypes.Terran_Factory then
        table.insert(factories, uid)
    elseif ut.type == tc.unittypes.Terran_Science_Facility then
        table.insert(science_facility, uid)
    elseif ut.type == tc.unittypes.Terran_Starport then
        table.insert(starports, uid)
    elseif ut.type == tc.unittypes.Terran_Bunker then
        table.insert(bunkers, uid)
    elseif ut.type == tc.unittypes.Terran_Firebat then
        table.insert(firebats, uid)
    elseif ut.type == tc.unittypes.Terran_Goliath then
        table.insert(goliaths, uid)
    elseif ut.type == tc.unittypes.Terran_Marine then
        table.insert(marines, uid)
    elseif ut.type == tc.unittypes.Terran_Medic then
        table.insert(medics, uid)
    elseif ut.type == tc.unittypes.Terran_Siege_Tank_Siege_Mode then
        table.insert(siege_tanks, uid)
    elseif ut.type == tc.unittypes.Terran_Siege_Tank_Tank_Mode then
        table.insert(tanks, uid)
    elseif ut.type == tc.unittypes.Terran_Vulture then
        table.insert(vultures, uid)
    elseif ut.type == tc.unittypes.Terran_Vulture_Spider_Mine then
        table.insert(spider_mines, uid)
    elseif ut.type == tc.unittypes.Terran_Battlecruiser then
        table.insert(battlecruisers, uid)
    elseif ut.type == tc.unittypes.Terran_Dropship then
        table.insert(dropships, uid)
    elseif ut.type == tc.unittypes.Terran_Science_Vessel then
        table.insert(science_vessels, uid)
    elseif ut.type == tc.unittypes.Terran_Valkyrie then
        table.insert(valkyries, uid)
    elseif ut.type == tc.unittypes.Terran_Wraith then
        table.insert(wraiths, uid)
    else print("scouting.identify_enemy_units crash") end
end

function scouting.main_quadrant(pos)
    if pos ~= nil then pos = pos.position end
    local quadrant = nil
    if pos ~= nil then
        if pos[1] > 256 and pos[2] <= 256 then
            quadrant = "A"
        elseif pos[1] <= 256 and pos[2] <= 256 then
            quadrant = "B"
        elseif pos[1] <= 256 and pos[2] > 256 then
            quadrant = "C"
        elseif pos[1] > 256 and pos[2] >= 256 then
            quadrant = "D"
        else
            print("scouting.main_quadrant crash")
        end
    end
    return quadrant
end

function scouting.pos_on_quad(pos)
    local quad = nil
    if pos ~= nil then
        if pos[1] > 256 and pos[2] <= 256 then
            quad = "A"
        elseif pos[1] <= 256 and pos[2] <= 256 then
            quad = "B"
        elseif pos[1] <= 256 and pos[2] > 256 then
            quad = "C"
        elseif pos[1] > 256 and pos[2] >= 256 then
            quad = "D"
        else print("scouting.pos_on_quad crash") end
    end
    return quad
end

function scouting.first_overlord(pos, uid, ut, actions, tc)
    quadrant = scouting.main_quadrant(pos)
    if quadrant == "A" then
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['B']['scout']['x'], quadrants['B']['scout']['y']))
        end
    elseif quadrant == "B" then
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['A']['scout']['x'], quadrants['A']['scout']['y']))
        end
    elseif quadrant == "C" then
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['D']['scout']['x'], quadrants['D']['scout']['y']))
        end
    elseif quadrant == "D" then
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['C']['scout']['x'], quadrants['C']['scout']['y']))
        end
    else print("scouting.first_overlord crash") end
    return actions
end

function scouting.second_overlord(ps, uid, ut, actions, tc)
    -- 2th overlord scout go to enemy's natural expansion.
    return actions
end

function scouting.eleven_drone_scout(scouting_drones, uid, ut, actions, tc)
    if scouting_drones[1]["uid"] == nil then scouting_drones[1] = {["uid"]=uid} end
    if scouting_drones[1]["uid"] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['B']['scout']['x'], quadrants['B']['scout']['y']) )
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['A']['scout']['x'], quadrants['A']['scout']['y']))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['D']['scout']['x'], quadrants['D']['scout']['y']))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['C']['scout']['x'], quadrants['C']['scout']['y']))
        else print("scouting.eleven_drone_scout crash") end
    end
    return {["actions"]=actions,["scouting_drones"]=scouting_drones}
end

function scouting.twelve_drone_scout(scouting_drones, uid, ut, actions, tc)
    if scouting_drones[2]["uid"] == nil and scouting_drones[1] ~= uid then 
        scouting_drones[2] = {["uid"]=uid} end
    if scouting_drones[2]["uid"] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        if quadrant == 'A' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['C']['scout']['x'], quadrants['C']['scout']['y']) )
        elseif quadrant == 'B' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['D']['scout']['x'], quadrants['D']['scout']['y']))
        elseif quadrant == 'C' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['A']['scout']['x'], quadrants['A']['scout']['y']))
        elseif quadrant == 'D' then
            table.insert(actions,
            tc.command(tc.command_unit, uid,
            tc.cmd.Move, -1,
            quadrants['B']['scout']['x'], quadrants['B']['scout']['y']))
        else print("scouting.twelve_drone_scout crash") end
    end
    return {["actions"]=actions,["scouting_drones"]=scouting_drones} 
end

function scouting.base_quadrant()
    -- return main quadrant
    return quadrant
end

function scouting.all_quadrants()
    -- return current data on all quadrants
    return quadrants
end

function scouting.lings()
    -- O=
end

function scouting.overlords()
    -- Split overlords after speed upgrade 
end

function scouting.overlord_sacrifice()
    -- How many gates? is there a robotics? 
end

function scouting.scourge_sacrifice()
    -- How many gates? is there a robotics?
end

function scouting.ling_sacrifice()
    -- Live for the Swarm! 
end

function scouting.explore_all_sectors(scouting_drones, uid, ut, actions, tc)

    -- this is not really exploring all 16 sectors
    -- it appears to send a drone to all bases on fs.

    -- check if drone is busy!
    -- check sectors!

    if tc.state.frame_from_bwapi - quadrants["A"][1] > 200 then
        quadrants["A"][1] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            56, 152))
        end

    elseif tc.state.frame_from_bwapi - quadrants["A"][2] > 200 then
        quadrants["A"][2] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            36, 470))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["A"][3] > 200 then
        quadrants["A"][3] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            476, 474))
        end

    elseif tc.state.frame_from_bwapi - quadrants["A"][4] > 200 then
        quadrants["A"][4] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            476, 34))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["B"][5] > 200 then
        quadrants["B"][5] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            156, 460))
        end

    elseif tc.state.frame_from_bwapi - quadrants["B"][6] > 200 then
        quadrants["B"][6] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            456, 350))
        end

    elseif tc.state.frame_from_bwapi - quadrants["B"][7] > 200 then
        quadrants["B"][7] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            350, 50))
        end

    elseif tc.state.frame_from_bwapi - quadrants["B"][8] > 200 then
        quadrants["B"][8] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            35, 35))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["C"][9] > 200 then
        quadrants["C"][9] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            216, 20))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["C"][10] > 200 then
        quadrants["C"][10] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            30, 290))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["C"][11] > 200 then
        quadrants["C"][11] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            490, 220))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["C"][12] > 200 then
        quadrants["C"][12] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            256, 256))
        end
    
    elseif tc.state.frame_from_bwapi - quadrants["D"][13] > 200 then
        quadrants["D"][13] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            315, 490))
        end
    else print("scouting.explore_all_sectors crash") end
    return actions
end

return scouting
