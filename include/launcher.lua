#!/usr/bin/env luajit

local inspect = require("inspect")
local ini = require("inifile")
local lfs = require("lfs")
local yaml = require("ophelia.lib.yaml")
local socket = require("socket")
local uuid = require("uuid")

local options = {}
local tools = {}

local bots = {}

-- count

local function count(t)
    local i = 0
    for k, v in pairs(t) do i = i + 1 end
    return i
end

-- get_options

function options.get_options(config_file)
    local raw = tools.read_file(config_file)
    local conf = yaml.parse(raw)
    return conf
end

-- get_session_conf

function options.get_session_conf(dir)
    -- get configuration
    local conf = {}
    conf.bwapi = {}
    conf.bots = dir .. '/bots/'
    conf.games = dir .. '/games/'
    conf.maps = dir .. '/maps/'
    conf.errors = dir .. '/Errors/'
    conf.bwapi.data = dir .. '/bwapi-data/'
    conf.bwapi.save = conf.bwapi.data .. 'save'
    conf.bwapi.read = conf.bwapi.data .. 'read'
    conf.bwapi.write = conf.bwapi.data .. 'write'
    conf.bwapi.ai = conf.bwapi.data .. 'AI'
    conf.bwapi.logs = conf.bwapi.data .. 'logs'
    -- making some dirs
    lfs.mkdir(conf['bots'])
    lfs.mkdir(conf['games'])
    lfs.mkdir(conf['errors'])
    lfs.mkdir(conf['bwapi']['data'])
    lfs.mkdir(conf['bwapi']['data'] .. "/bwapi")
    lfs.mkdir(conf['bwapi']['data'] .. "/tm")
    lfs.mkdir(conf['bwapi']['save'])
    lfs.mkdir(conf['bwapi']['read'])
    lfs.mkdir(conf['bwapi']['write'])
    lfs.mkdir(conf['bwapi']['ai'])
    lfs.mkdir(conf['bwapi']['logs'])
    return conf
end

-- pass

function tools.pass()
    -- do nothing
    return 'ok'
end

-- size

function tools.size(...)
    local args = {...}
    local arg1 = args[1]
    return(type(arg1) == 'table') and count(args[1]) or count(args)
end

-- update_registry

function tools.update_registry()
    os.execute("bash /opt/bw/include/wine_registry.sh")
end

-- prepare_bwapi

function tools.prepare_bwapi(bwapi, bot, map, conf, session)
    --
    -- Preparing bwapi.ini
    --
    if tools.size(bot) > 2 then
        bwapi["ai"]["ai"] = "/opt/StarCraft/bwapi-data/AI/" .. bot['name'] .. ".dll, HUMAN"
        --bwapi["ai"]["tournament"] = "bwapi-data/tm.dll"
        bwapi["auto_menu"]["race"] = bot["race"]
        bwapi["auto_menu"]["wait_for_min_players"] = 2
        bwapi["starcraft"]["speed_override"] = 42
        bwapi["auto_menu"]["game"] = bot["name"]
        bwapi["auto_menu"]["map"] = map
    elseif tools.size(bot) == 2 then
        -- is very diffrent to handle things for bot vs bot!
        bwapi["ai"]["ai"] = "/opt/StarCraft/bwapi-data/AI/"
            .. bot[1]['name']
            .. ".dll, "
            .. "/opt/StarCraft/bwapi-data/AI/"
            .. bot[2]['name']
            .. ".dll"
        bwapi["ai"]["tournament"] = "bwapi-data/tm/"
            .. bot[1]['bwapi']
            .. ".dll"
        bwapi["auto_menu"]["race"] = bot[1]["race"]
        bwapi["auto_menu"]["wait_for_min_players"] = 2
        bwapi["starcraft"]["speed_override"] = 0
        bwapi["auto_menu"]["game"] = bot[1]["name"]
        bwapi["auto_menu"]["map"] = map
    else
        print('crash tools.prepare_bwapi()')
    end
    -- save bwapi.ini
    ini.save(session["bwapi"]["data"] .. "bwapi.ini", bwapi)
end

-- get_bwapi_ini

function tools.get_bwapi_ini()
    local bwapi = ini.parse("/opt/bw/include/bwapi-data/bwapi.ini")
    -- BWAPI version 4.2.0 and higher ONLY
    -- FIRST (default), use the first character in the list
    -- WAIT, stop at this screen
    -- else the character with the given value is used/created
    --local character_name = "FIRST"
    -- BWAPI version 4.2.0 and higher ONLY
    -- Text that appears in the drop-down list below the Game Type.
    --local game_type_extra = ""
    --print(character_name, game_type_extra)
    return bwapi
end

-- prepare_tm

function tools.prepare_tm(bot, session)
    --
    -- Preparing tm.dll
    --
    os.execute("cp /opt/bw/include/tm/" .. bot["bwapi"] .. ".dll " .. session["bwapi"]["data"] .. "/tm.dll")
end

-- prepare_ai

function tools.prepare_ai(bot, session)
    --
    -- Preparing to fight
    --
    local name = bot["name"]:gsub("% ", "+")
    os.execute("cp " .. "/opt/bw/include/bwapi-data/"
        .. bot["bwapi"] .. ".dll "
        .. session["bwapi"]["data"] .. "bwapi/")
    os.execute("cp " .. "/opt/bw/include/bwapi-data/"
        .. bot["bwapi"] .. ".dll "
        .. session["bwapi"]["data"] .. "BWAPI.dll")
    os.execute("cp -r " .. session["bots"] .. name .. "/AI/* " .. session["bwapi"]["ai"])
end

-- start_game

function tools.start_game(bot, map, session)
    --
    -- Launch the game!
    --
    lfs.chdir('/opt/StarCraft')
    if tools.size(bot) > 2 then

        if bot['type'] == 'Java' then
            tools.pass()
        elseif bot['type'] == 'EXE' then
            tools.pass()
        elseif bot['type'] == 'Linux' then
            cmd = "wine bwheadless.exe -e /opt/StarCraft/StarCraft.exe "
                .. "-l /opt/StarCraft/bwapi-data/BWAPI.dll --host --name "
                .. bot['name'] .. " --game " .. bot['name'] .. " --race "
                .. string.sub(bot['race'], 1, 1) .. " --map " .. map
                .. "& ophelia& wine Chaoslauncher/Chaoslauncher.exe"
        else
            cmd = "wine bwheadless.exe -e /opt/StarCraft/StarCraft.exe "
                .. "-l /opt/StarCraft/bwapi-data/BWAPI.dll --host --name "
                .. bot['name'] .. " --game " .. bot['name'] .. " --race "
                .. string.sub(bot['race'], 1, 1) .. " --map " .. map
                .. "& wine Chaoslauncher/Chaoslauncher.exe"
        end
        local file = assert(io.popen(cmd, 'r'))
        local output = file:read('*all')
        file:close()
        --print(output)
    elseif tools.size(bot) == 2 then
        -- zmq and I'm ready to fuck shit up
    else
        --
        print("crash tools.start_game()")
    end
end

-- read_file

function tools.read_file(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

-- get_bot

function bots.get_bot(name, bots_directory)
    local home = bots_directory .. name
    local file = tools.read_file(home .. "/bot.yml")
    local bot = yaml.parse(file)
    return bot
end

uuid.randomseed(socket.gettime()*10000)

local session_uuid = uuid()

local things = {}

local conf = options.get_options("/opt/bw/include/bw.yml")

things['map'] = "maps/BroodWar/torchup/\\(4\\)Polypoid.scx"
things['directory'] = "/opt/StarCraft"

local session = options.get_session_conf(things['directory'])

if lfs.chdir(session['bots']) then
    ophelia = bots.get_bot('Ophelia', session['bots'])
    tools.update_registry()
    tools.prepare_bwapi(
        tools.get_bwapi_ini(),
        ophelia,
        things['map'],
        conf,
        session
    )
    tools.prepare_tm(ophelia, session)
    tools.prepare_ai(ophelia, session)
    tools.start_game(
        ophelia,
        things['map'],
        session
    )
end
