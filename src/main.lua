#!/usr/bin/env luajit
--
-- We don't know where she is from, or even what strain she is.
--

--local inspect = require("inspect")
local sys = require("sys")
local torch = require("torch")
local argparse = require("argparse")
local socket = require("socket")
local uuid = require("uuid")
local tc = require("torchcraft")
local scouting = require("ophelia.scouting")
local economy = require("ophelia.economy")
local tools = require("ophelia.tools")
-- Set default float tensor type
torch.setdefaulttensortype('torch.FloatTensor')
-- Debug can take values 0, 1, 2 (from no output to most verbose)
tc.DEBUG = 0
-- Set random seed
uuid.randomseed(socket.gettime()*10000)
-- Spawn session id
local spawn_uuid = uuid()

-- Do not break the laws of physics.

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
-- Guarantee a single run
local restarts = -1
-- Good luck, have fun!
while restarts < 0 do
    restarts = restarts + 1
    tc:init(hostname, port)
    local ophelia = {}
    local enemy = nil
    local loops = 1
    local update = tc:connect(port)
    local tm = torch.Timer()
    if tc.DEBUG > 1 then
        print('Received init: ', update)
    end
    assert(tc.state.replay == false)
    local setup = {
        tc.command(tc.set_speed, 0), tc.command(tc.set_gui, 1),
        tc.command(tc.set_cmd_optim, 1),
    }
    tc:send({table.concat(setup, ':')})
    while not tc.state.game_ended do
        local actions = {}
        tm:reset()
        -- Update received from game engine
        update = tc:receive()
        loops = loops + 1
        if tc.DEBUG > 1 then
            print('Received update: ', update)
        end
        -- Ophelia's player info
        for k, v in pairs(tc.state.player_info) do
            if v['name'] == "Ophelia" then
                ophelia = v
            end
            if v['is_enemy'] == true then
                enemy = v
            end
        end
        local resources = tc.state.frame["getResources"](tc.state.frame, ophelia['id'])
        if tc.state.battle_frame_count % skip_frames == 0 then
            if enemy then
                print("Ophelia vs "..enemy['name'])
            end
            actions = economy.manage_game_economy(actions, enemy, resources, tc)
            -- bot identify enemy units
            local enemy_units = scouting.identify_enemy_units(tc)
            tools.pass(enemy_units)
            -- note how this seem to be backwards ?
            if scouting.identify_enemy_race() then
                print("Ophelia vs " .. scouting.identify_enemy_race())
            end
            -- starting init offense and defense (!!!)
            --inspect(enemy_units)
        elseif tc.state.game_ended then
            -- wp
            print("gg")
            break
        else
            tools.pass()
        end
        -- if debug make some noise!
        if tc.DEBUG > 1 then
            print('Frame ' .. tc.state.battle_frame_count
            .. ' consume ' .. tm:time().real .. ' seconds')
            print("Sending actions: " .. actions)
        end
        tc:send({table.concat(actions, ':')})
    end
    tc:close()
    collectgarbage()
    sys.sleep(0.0042)
    print("So Long, and Thanks for All the Lings!")
    collectgarbage()
end
