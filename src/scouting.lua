-- Live for the swarm!
-- scouting overlords,
-- scouting drones.

local fun = require("moses")
local utils = require("torchcraft.utils")

-- one at 11 drone,
-- two at 12 drone, 200 mineral.
local scouting = {}

-- Map is not territory, but
-- since handling 512x512 for all things.
local quadrants = {}
quadrants["A"] = {["scout"]={["x"]=450,["y"]=50}}
quadrants["B"] = {["scout"]={["x"]=50,["y"]=50}}
quadrants["C"] = {["scout"]={["x"]=50,["y"]=450}}
quadrants["D"] = {["scout"]={["x"]=450,["y"]=450}}

function scouting.main_quadrant(pos)
    if pos ~= nil then pos = pos.position end
    local quadrant = nil
    if pos ~= nil then
        if pos[1] > 256 and pos[2] <= 256 then
            quadrant = "A"
        elseif pos[1] <= 256 and pos[2] <= 256 then
            quadrant = "B"
        elseif post[1] <= 256 and pos[2] > 256 then
            quadrant = "C"
        elseif pos[1] > 256 and pos[2] >= 256 then
            quadrant = "D"
        else
            print("let it crash")
        end
    end
    return quadrant
end

function scouting.first_overlord(pos, uid, ut, actions, tc)
    local quadrant = scouting.main_quadrant(pos)
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

function scouting.eleven_drone_scout(scouting_drones, uid, ut, actions, tc)
    if scouting_drones[1]["uid"] == nil then scouting_drones[1] = {["uid"]=uid} end
    if scouting_drones[1]["uid"] == uid and not utils.is_in(ut.order,
        tc.command2order[tc.unitcommandtypes.Right_Click_Position]) then
        table.insert(actions,
        tc.command(tc.command_unit, uid,
        tc.cmd.Move, -1,
        56, 152))
    return {["actions"]=actions,["scouting_drones"]=scouting_drones}
end

function scouting.twelve_drone_scout()
    -- oh raining day
end

return scouting
