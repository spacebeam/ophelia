#!/usr/bin/env luajit
--
-- We don't know where she is from, or even what strain she is. 
--
require("sys")
require("torch")
local inspect = require("inspect")
local argparse = require("argparse")
local socket = require("socket")
local uuid = require("uuid")
local fun = require("moses")
local lc = require("lovecraft")
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
lc.DEBUG = 0 
-- Set random seed
uuid.randomseed(socket.gettime()*10000)
-- Spawn session id
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
    lc:init(hostname, port)
    local loops = 1
    local update = lc:connect(port)
    if lc.DEBUG > 1 then
        print('Received init: ', update)
    end
    assert(lc.state.replay == false)
    local setup = {
        lc.command(lc.set_speed, 0), lc.command(lc.set_gui, 1),
        lc.command(lc.set_cmd_optim, 1),
    }
    lc:send({table.concat(setup, ':')})

    local ophelia = {}
    local units = {}
    local resources = {}

    -- Measure execution time
    local tm = torch.Timer()

    while not lc.state.game_ended do
        local actions = {}
        tm:reset()
        -- receive update from game engine
        update = lc:receive()

        -- How enable debug in a way that fit this "crafting" style?
        if lc.DEBUG > 1 then
            print('Received update: ', update)
        end
        -- O=
        for k, v in pairs(lc.state.player_info) do
            if v['name'] == "Ophelia" then
                ophelia = v
            end
        end

        -- !!

        --print(lc.state.map_name)
        
        --print(lc.state.ground_height_data)

        --print(lc.state.buildable_data)
        
        --for k,v in pairs(lc.state.units_myself) do
        --    for f,e in pairs(v) do
        --        --print(v[f])
        --        print(v['hp'])
        --        print(v['position'][1])
        --        print(v['position'][2])
        --        --print(v['remainingBuildTrainTime'])
        --    end
        --end

        --for k,v in pairs(lc.state.start_locations) do
        --    print(k)
        --    for a,b in pairs(lc.state.start_locations[k]) do
        --        print(a)
        --        print(b)
        --    end
        --    print(v)
        --end
        --

        -- !?
        
        --print(inspect(getmetatable(lc.state.frame)))

        --print(inspect(lc.state.frame["toTable"](lc.state.frame)))

        --units = lc.state.frame["getUnits"](lc.state.frame, ophelia['id'])
        --resources = lc.state.frame["getResources"](lc.state.frame, ophelia['id'])
        
        --print(inspect(units))

        -- ?!
        
        loops = loops + 1
        if lc.state.battle_frame_count % skip_frames == 0 then

            -- here is exactly where actions start to execute
            -- 9734 is not ZvP standard play but this is just a 9734 hack for now. (=
            actions = economy.manage_9734_economy(actions, lc)
           
            -- sometimes the first overlord defines our opening!
            actions = scouting.first_overlord(actions, lc)
            
            -- can't do much if don't know what you are against
            enemy = scouting.identify_enemy_units(lc.state.units_enemy, lc)

            if scouting.identify_enemy_race() then
                print("Ophelia vs " .. scouting.identify_enemy_race())
            end

        elseif lc.state.game_ended then
            break
        else
            -- skip frame do nothing
        end
        
        -- if debug make some noise!
        if lc.DEBUG > 1 then
            print('Frame ' .. lc.state.battle_frame_count  
            .. ' consume ' .. tm:time().real .. ' seconds')
            print("Sending actions: " .. actions)
        end
        
        lc:send({table.concat(actions, ':')})
    end
    lc:close()
    collectgarbage()
    sys.sleep(0.0042)
    print("So Long, and Thanks for All the Fish!")
    collectgarbage()
end
