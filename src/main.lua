#!/usr/bin/env luajit
--
-- We don't know where she is from, or even what strain she is. 
--
require("sys")
require("torch")
local argparse = require("argparse")
local socket = require("socket")
local uuid = require("uuid")
local tc = require("torchcraft")
local counters = require("ophelia.counters")
local economy = require("ophelia.economy")
local openings = require("ophelia.openings")
local scouting = require("ophelia.scouting")
local tactics = require("ophelia.tactics")
local tools = require("ophelia.tools")
local zstreams = require("ophelia.zstreams")
-- Set default float tensor type
torch.setdefaulttensortype('torch.FloatTensor')
-- Debug can take values 0, 1, 2 (from no output to most verbose)
tc.DEBUG = 0 
-- Set random seed
uuid.randomseed(socket.gettime()*10000)
-- Session id
local spawn_uuid = uuid()
print("Ophelia's session " .. spawn_uuid)
-- CLI argument parser
local parser = argparse() {
    name = "Ophelia",
    description = "If not for her we wouldn't even be in this predicament.",
    epilog = "And now, this ridiculous plan."
}
parser:option("-t --hostname", "Give hostname/ip to VM", "127.0.0.1")
parser:option("-p --port", "Port for TorchCraft", 11111)
-- Parse your arguments
local args = parser:parse()
local hostname = args['hostname']
local port = args['port'] 
-- Skip BWAPI frames
local skip_frames = 7
local restarts = -1
while restarts < 0 do
    restarts = restarts + 1
    tc:init(hostname, port)
    local loops = 1
    local update = tc:connect(port)
    if tc.DEBUG > 1 then
        print('Received init: ', update)
    end
    assert(tc.state.replay == false)
    local setup = {
        tc.command(tc.set_speed, 0), tc.command(tc.set_gui, 1),
        tc.command(tc.set_cmd_optim, 1),
    }
    tc:send({table.concat(setup, ':')})

    -- Measure execution time
    local tm = torch.Timer()

    while not tc.state.game_ended do
        local actions = {}
        tm:reset()
        -- receive update from game engine
        update = tc:receive()

        -- How enable debug in a way that fit this "crafting" style?
        if tc.DEBUG > 1 then
            print('Received update: ', update)
        end
        
        loops = loops + 1
        if tc.state.battle_frame_count % skip_frames == 0 then

            -- here is exactly where actions start to execute
            actions = economy.manage_economy(actions, tc)
           
            -- sometimes the first overlord defines what opening!
            actions = scouting.first_overlord(actions, tc)
            
            -- can't do much if don't know what you are against
            enemy = scouting.identify_enemy_units(tc.state.units_enemy, tc)


        elseif tc.state.game_ended then
            break
        else
            -- skip frame do nothing
        end
        
        print('Time elapsed ' .. tm:time().real .. ' seconds')
        
        -- if debug make some noise!
        if tc.DEBUG > 1 then
            print("Sending actions: " .. actions)
        end
        
        tc:send({table.concat(actions, ':')})
    end
    tc:close()
    collectgarbage()
    sys.sleep(0.042)
    print("So Long, and Thanks for All the Fish!")
    collectgarbage()
end
