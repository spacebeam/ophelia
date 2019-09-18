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

local quadrant = nil
-- Map is not territory, but...
-- since handling 512x512 for all things.
local quadrants = {}
quadrants["A"] = {
    ["scout"] = {["x"]=450,["y"]=50},
    ["main"] = {["x"]=476,["y"]=34},
    ["natural"] = {["x"]=360,["y"]=60},
    ["second"] = {["x"]=490,["y"]=220},
    ["center"] = nil,
}
quadrants["B"] = {
    ["scout"] = {["x"]=50,["y"]=50},
    ["main"] = {["x"]=35,["y"]=35},
    ["natural"] = {["x"]=56,["y"]=152},
    ["second"] = {["x"]=216,["y"]=20},
    ["center"] = {["x"]=256,["y"]=256},
}
quadrants["C"] = {
    ["scout"] = {["x"]=50,["y"]=450},
    ["main"] = {["x"]=36,["y"]=470},
    ["natural"] = {["x"]=146,["y"]=448},
    ["second"] = {["x"]=30,["y"]=290},
    ["center"] = nil,
}
quadrants["D"] = {
    ["scout"] = {["x"]=450,["y"]=450},
    ["main"] = {["x"]=476,["y"]=474},
    ["natural"] = {["x"]=442,["y"]=356},
    ["second"] = {["x"]=315,["y"]=490},
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
    -- Awaken my child, and embrace the glory that is your birthright.
    if ut.type == tc.unittypes.Zerg_Overlord then
        print("I see an overlord!")
    elseif ut.type == tc.unittypes.Zerg_Drone then
        print("I see a drone!")
    elseif ut.type == tc.unittypes.Zerg_Zergling then
        print("I see a zergling!")
    elseif ut.type == tc.unittypes.Zerg_Mutalisk then
        print("I see a mutalisk!")
    elseif ut.type == tc.unittypes.Zerg_Scourge then
        print("I see a scourge!")
    elseif ut.type == tc.unittypes.Zerg_Hatchery then
        print("I see a hatchery!")
    elseif ut.type == tc.unittypes.Zerg_Extractor then
        print("I see a extractor")
    elseif ut.type == tc.unittypes.Zerg_Spawning_Pool then
        print("See a spawning pool")
    elseif ut.type == tc.unittypes.Zerg_Evolution_Chamber then
        print("See an evolution chamber")
    elseif ut.type == tc.unittypes.Zerg_Lair then
        print("See a lair")
    elseif ut.type == tc.unittypes.Zerg_Spire then
        print("See a spire")
    -- Why give my life for Aiur?
    elseif ut.type == tc.unittypes.Protoss_Nexus then
        print("See a nexus!")
    elseif ut.type == tc.unittypes.Protoss_Probe then
        print("See a probe!")
    elseif ut.type == tc.unittypes.Protoss_Zealot then
        print("See a zealot!")
    elseif ut.type == tc.unittypes.Protoss_Dragoon then
        print("See a goon!")
    elseif ut.type == tc.unittypes.Protoss_Pylon then
        print("See a pylon!")
    elseif ut.type == tc.unittypes.Protoss_Forge then
        print("See a forge!")
    elseif ut.type == tc.unittypes.Protoss_Photon_Cannon then
        print("See a cannon!")
    elseif ut.type == tc.unittypes.Protoss_Gateway then
        print("See a gateway")
    elseif ut.type == tc.unittypes.Protoss_Assimilator then
        print("See a assimilator")
    elseif ut.type == tc.unittypes.Protoss_Cybernetics_Core then
        print("See a cybernetics core")
    elseif ut.type == tc.unittypes.Protoss_Citadel_of_Adun then
        print("See a citadel")
    elseif ut.type == tc.unittypes.Protoss_Robotics_Facility then
        print("See a robotics")
    elseif ut.type == tc.unittypes.Protoss_Stargate then
        print("See a stargate")
    -- God bless terran rednecks
    elseif ut.type == tc.unittypes.Terran_SCV then
        print("See a SCV")
    elseif ut.type == tc.unittypes.Terran_Command_Center then
        print("See a command center")
    elseif ut.type == tc.unittypes.Terran_Supply_Depot then
        print("See a supply depot!")
    elseif ut.type == tc.unittypes.Terran_Refinery then
        print("See a refinery!")
    elseif ut.type == tc.unittypes.Terran_Barracks then
        print("See a barracks!")
    elseif ut.type == tc.unittypes.Terran_Engineering_Bay then
        print("See a engineering bay!")
    elseif ut.type == tc.unittypes.Terran_Missile_Turret then
        print("See a missile turret")
    elseif ut.type == tc.unittypes.Terran_Academy then
        print("See an academy")
    elseif ut.type == tc.unittypes.Terran_Armory then
        print("See an armory")
    elseif ut.type == tc.unittypes.Terran_Factory then
        print("See a factory!")
    elseif ut.type == tc.unittypes.Terran_Science_Facility then
        print("See a science facility")
    elseif ut.type == tc.unittypes.Terran_Starport then
        print("See a starport!")
    elseif ut.type == tc.unittypes.Terran_Bunker then
        print("See a bunker")
    elseif ut.type == tc.unittypes.Terran_Firebat then
        print("See a firebat!")
    elseif ut.type == tc.unittypes.Terran_Goliath then
        print("See a goliath")
    elseif ut.type == tc.unittypes.Terran_Marine then
        print("See a marine!")
    elseif ut.type == tc.unittypes.Terran_Medic then
        print("See a medic!")
    elseif ut.type == tc.unittypes.Terran_Siege_Tank_Siege_Mode then
        print("See a siege tank!")
    elseif ut.type == tc.unittypes.Terran_Siege_Tank_Tank_Mode then
        print("See a tank!")
    elseif ut.type == tc.unittypes.Terran_Vulture then
        print("See a vulture!")
    elseif ut.type == tc.unittypes.Terran_Vulture_Spider_Mine then
        print("See a mine!")
    elseif ut.type == tc.unittypes.Terran_Battlecruiser then
        print("See a battlecruiser")
    elseif ut.type == tc.unittypes.Terran_Dropship then
        print("See a dropship")
    elseif ut.type == tc.unittypes.Terran_Science_Vessel then
        print("See a science vessel")
    elseif ut.type == tc.unittypes.Terran_Valkyrie then
        print("See a valkyrie!")
    elseif ut.type == tc.unittypes.Terran_Wraith then
        print("See a wraith!")
    end
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
    -- extract timing from zero's guide
end

function scouting.overlords()
    -- extract timing from zero's guide
end

function scouting.overlord_sacrifice()
    -- hell yeah
end

function scouting.scourge_sacrifice()
    -- 9=
end

function scouting.ling_sacrifice()
    -- D=
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
