#!/usr/bin/env luajit
--
--
--local inspect = require("inspect")

local lfs = require("lfs")

local socket = require("socket")
local uuid = require("uuid")

local options = require("ophelia.options")
local tools = require("ophelia.tools")


uuid.randomseed(socket.gettime()*10000)

local session_uuid = uuid()


local things = {}


things['map'] = "maps/BroodWar/torchup/\\(4\\)Polypoid.scx"
things['directory'] = "/opt/StarCraft"

local session = options.get_session_conf(things['directory'])

if lfs.chdir(session['bots']) then
    ophelia = bots.get_bot('ophelia', session['bots'])
    tools.update_registry()
    tools.prepare_bwapi(
        tools.get_bwapi_ini(),
        ophelia,
        things['map'],
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
