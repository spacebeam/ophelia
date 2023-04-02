-- bw thread run in parallel with love2d

local sys = require("sys")
local torch = require("torch")
local tc = require("torchcraft")

-- Set default float tensor type
torch.setdefaulttensortype('torch.FloatTensor')

-- Debug can take values 0, 1, 2 (from no output to most verbose)
tc.DEBUG = 0

local ophelia = {}
local hostname = '127.0.0.1'
local port = 11111
local skip_frames = 7
local restarts = -1

-- Good luck, have fun!
while restarts < 0 do
    restarts = restarts + 1
    -- init connection to bw engine
    tc:init(hostname, port)
    local enemy = nil
    local loops = 1
    local update = tc:connect(port)
    local timer = torch.Timer()
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
        timer:reset()
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
        if tc.state.battle_frame_count % skip_frames == 0 then
            local resources = tc.state.frame["getResources"](tc.state.frame, ophelia['id'])
            love.thread.getChannel('resources'):push(resources)
            love.thread.getChannel('enemy'):push(enemy)
            if  enemy and tc.DEBUG > 1 then
                print("Ophelia vs "..enemy['name'])
            end
 
            -- I need "actions" channel linked on BW thread
            actions = love.thread.getChannel('actions'):pop()
            if not actions then
                actions = {}
            end

            -- go action, missing actions

        elseif tc.state.game_ended then
            -- wp
            print('gg')
            break
        end
        if tc.DEBUG > 1 then
            print('Frame ' .. tc.state.battle_frame_count
            .. ' consume ' .. timer:time().real .. ' seconds')
            print("Sending actions: " .. actions)
        end
        tc:send({table.concat(actions, ':')})
    end
    tc:close()
    collectgarbage()
    sys.sleep(0.0042)
    print('So long, and Thanks for All the Lings!')
    collectgarbage()
end
