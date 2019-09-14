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

-- Map is not territory, but...
-- since handling 512x512 for all things.
local quadrants = {}
quadrants["A"] = {["scout"]={["x"]=450,["y"]=50}}
quadrants["B"] = {["scout"]={["x"]=50,["y"]=50}}
quadrants["C"] = {["scout"]={["x"]=50,["y"]=450}}
quadrants["D"] = {["scout"]={["x"]=450,["y"]=450}}

local quadrant = nil


-- eye roll on this for now!
local test_all_regions = {"B", "C", "D", "A", "C", "D", "A", "B", "B", "C", "A", "B", "D"}


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
            print("let it crash")
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
        else print("let it crash") end
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
    else print("let it crash") end
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
        else print("let it crash") end
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
        else print("let it crash") end
    end
    return {["actions"]=actions,["scouting_drones"]=scouting_drones} 
end

function scouting.base_quadrant()
    -- return main quadrant
    return quadrant
end

function scouting.all_quadrants()
    -- return current information on all quadrants
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

    if tc.state.frame_from_bwapi - colonies[1] > 200 then
        colonies[1] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            56, 152))
            print("B's natural " .. scouting.pos_on_quad({56,152})==test_all_regions[1])
        end

    elseif tc.state.frame_from_bwapi - colonies[2] > 200 then
        colonies[2] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            36, 470))
            print("C's main " .. scouting.pos_on_quad({36,470})==test_all_regions[2])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[3] > 200 then
        colonies[3] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            476, 474))
            print("D's main " .. scouting.pos_on_quad({476,474})==test_all_regions[3])
        end

    elseif tc.state.frame_from_bwapi - colonies[4] > 200 then
        colonies[4] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            476, 34))
            print("A's main " .. scouting.pos_on_quad({476,34})==test_all_regions[4])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[5] > 200 then
        colonies[5] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            156, 460))
            print("C's natural " .. scouting.pos_on_quad({156,460})==test_all_regions[5])
        end

    elseif tc.state.frame_from_bwapi - colonies[6] > 200 then
        colonies[6] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            456, 350))
            print("D's natural " .. scouting.pos_on_quad({456,350})==test_all_regions[6])
        end

    elseif tc.state.frame_from_bwapi - colonies[7] > 200 then
        colonies[7] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            350, 50))
            print("A's natural " .. scouting.pos_on_quad({350,50})==test_all_regions[7])
        end

    elseif tc.state.frame_from_bwapi - colonies[8] > 200 then
        colonies[8] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            35, 35))
            print("B's main " .. scouting.pos_on_quad({35,35})==test_all_regions[8])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[9] > 200 then
        colonies[9] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            216, 20))
            print("B's 2th expansion " .. scouting.pos_on_quad({216,20})==test_all_regions[9])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[10] > 200 then
        colonies[10] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            30, 290))
            print("C's 2th expansion " .. scouting.pos_on_quad({30,290})==test_all_regions[10])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[11] > 200 then
        colonies[11] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            490, 220))
            print("A's 2th expansion " .. scouting.pos_on_quad({490,220})==test_all_regions[11])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[12] > 200 then
        colonies[12] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            256, 256))
            print("B in the center " .. scouting.pos_on_quad({256,256})==test_all_regions[12])
        end
    
    elseif tc.state.frame_from_bwapi - colonies[13] > 200 then
        colonies[13] = tc.state.frame_from_bwapi
        if not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Build])
            and not utils.is_in(ut.order,
            tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
            table.insert(actions,
            tc.command(tc.command_unit, uid, tc.cmd.Move, -1,
            315, 490))
            print("D's 2th expansion " .. scouting.pos_on_quad({315,490})==test_all_regions[13])
        end
    else print("let it crash") end
    return actions
end

return scouting
