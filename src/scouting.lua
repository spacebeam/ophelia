
-- Scouting overlords,
-- scouting drones,
-- scouting lings,
-- scouting scourges.


-- Zerg vs Protoss

-- notes: after overpool if protoss scout you first < 2 minute mark, you must go zerglings.

-- 11 drone scout, 12 natural, 2th hatch,

-- 11 3th hatch at new expansion,

-- if they scout you first < 2 minute mark, spawn 6 lings,

-- after the 3th hatch, create 1th gas extractor at main,

-- with the first 50 gas build a hydralisk den,

-- notes: following this playstyle don't waste the first lings trying to get them inside protoss main.

-- as soon as the hydralisk den is done get speed, and move your focus to powering,

-- if fast adun be aware of where is the first zealot.

-- notes: early timing window of 6, 7 hydras to preassure against adun first, you MUST break the forge.

-- notes: 6,7 hydras 6 put preassure the 7th stay back home defending of any early corsair play.

-- keep powering, get 5th hach and lair, after hydra speed complete get range,

-- make sure you position the hydras in a way that after range is complete they start to attack the forge,

-- after preassure and dealing hopefully with the forge get zergling speed,

-- preassure attack with the first 12 hydras and initial 6 lings,

-- preasure and pull back, after 5th hatch get 1th evolution chamber and keep powering,

-- sacrifice a scouting overlord, and make overlords starting now only on the natural,

-- send the damage hydras from initial preassure back to defend from any late corsair attack,

-- if they attack or put preassure defend with sunken at each base and lings, mix hydra lings and a move,

-- scout its main with overlords if fast gates start making hydras after 5th hatch,

-- scout notes: the overlord inside the enemy base needs to scout the amount of gateways and the robotics timing.

-- if there is templar archives, start making hydras after 6th hatch,

-- if lurker play, get lurker and overlord speed if not get spire after lair,

-- if no stargate put overlords around, keep powering, get sunkens and 5 hatch asap,

-- after lair, put spire and 2th gas extractor at the natural,

-- if anything happens defend with lings and sunkens...

-- counter attack with lings and hydras put preassure after defend if anything happens,

-- after spair get 5 mutalisk, lurker upgrade and evolution chamber

-- get overlord speed and overlords scouting all around the map,

-- get 4th expansion on the other side of the map,

-- after 5 mutalisk, keep powering, get more hatcheries, soon the lurker upgrade will be done, get overlord speed,

-- check with mutas if enemy have a 3th base, if so start powering the 4th expansion, if not keep getting hydras,

-- block any DT incursion, and be prepare for drops,

-- keep powering, 2 more hatcheries in 4th asap, get 2th evolution chamber,

-- get natural in the 4th base, prepare to backstab with 3 groups of lings and hydra,

-- get hive, keep upgrades and powering in the last expansions, if you follow 9734 by now you have powerful magic,

-- greed notes: just keep one base ahead at all times, usually even if you have 2 more one of those is a trap.

-- upgrade notes: get second range attack upgrade and 2th evolution chamber,

-- hive notes: upgrade only after having 2 working evolution chambers,

-- don't put the 5th expansion until 1, you are sure your enemy is getting its 4th, and 2, you have dark swarm.

-- after hive get addrenals and 3th evolution chamber,

-- defense notes: on high ground is nice to usually put 3 sunkens.

-- notes ling/lurker swich: after getting defiler all gas goes into lurkers.

-- End of 9734 analysis.


local fun = require("moses")
local utils = require("torchcraft.utils")
local tools = require("ophelia.tools")

-- one at 11 drone,
-- two at 12 drone, 200 mineral.
local scouting = {}

local vs_zerg = false

local vs_protoss = false

local vs_terran = false

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

function scouting.identify_enemy_race()
    --
    -- identify enemy race
    --
    local race = nil
    local zerg_units = 0
    local protoss_units = 0
    local terran_units = 0 
    for k,v in pairs(enemy["Z"]["units"]) do
        zerg_units = zerg_units + fun.size(enemy["Z"]["units"][k])
    end
    for k,v in pairs(enemy["P"]["units"]) do
        protoss_units = protoss_units + fun.size(enemy["P"]["units"][k])
    end
    for k,v in pairs(enemy["T"]["units"]) do
        terran_units = terran_units + fun.size(enemy["T"]["units"][k])
    end
    if zerg_units >= 1 then
        vs_zerg = true
        race = 'Zerg'
    end
    if protoss_units >= 1 then
        vs_protoss = true
        race = 'Protoss' 
    end
    if terran_units >= 1 then
        vs_terran = true
        race = 'Terran'
    end
     return race
end

function scouting.identify_enemy_units(enemy_units, tc)
    --
    -- What you know can't really hurt you!
    --
    local overlords = {}
    local drones = {}
    local lings = {}
    local mutas = {}
    local scourges = {}
    local hatcheries = {}
    local extractors = {}
    local spawning_pool = {}
    local evolution_chamber = {}
    local lair = {}
    local spire = {}
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
    for uid, ut in pairs(enemy_units) do
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
        else 
            -- do nothing, ignoring unfiltered unit types..
        end
    end
    enemy["Z"]["units"]["overlords"] = overlords 
    enemy["Z"]["units"]["drones"] = drones
    enemy["Z"]["units"]["lings"] = lings 
    enemy["Z"]["units"]["mutas"] = mutas
    enemy["Z"]["units"]["scourges"] = scourges
    enemy["Z"]["units"]["hatcheries"] = hatcheries
    enemy["Z"]["units"]["extractors"] = extractors
    enemy["Z"]["units"]["spawning_pool"] = spawning_pool
    enemy["Z"]["units"]["evolution_chamber"] = evolution_chamber
    enemy["Z"]["units"]["lair"] = lair
    enemy["Z"]["units"]["spire"] = spire
    enemy["P"]["units"]["probes"] = probes 
    enemy["P"]["units"]["zealots"] = zealots
    enemy["P"]["units"]["dragoons"] = dragoons
    enemy["P"]["units"]["archons"] = archons
    enemy["P"]["units"]["dark_archons"] = dark_archons
    enemy["P"]["units"]["dark_templars"] = dark_templars
    enemy["P"]["units"]["high_templars"] = high_templars
    enemy["P"]["units"]["reavers"] = reavers
    enemy["P"]["units"]["scarabs"] = scarabs
    enemy["P"]["units"]["corsairs"] = corsairs
    enemy["P"]["units"]["observers"] = observers
    enemy["P"]["units"]["scouts"] = scouts
    enemy["P"]["units"]["shuttles"] = shuttles
    enemy["P"]["units"]["nexus"] = nexus
    enemy["P"]["units"]["observatory"] = observatory
    enemy["P"]["units"]["robotics_facility"] = robotics_facility
    enemy["P"]["units"]["robotics_support_bay"] = robotics_support_bay
    enemy["P"]["units"]["pylons"] = pylons
    enemy["P"]["units"]["forge"] = forge
    enemy["P"]["units"]["cannons"] = cannons
    enemy["P"]["units"]["gateways"] = gateways
    enemy["P"]["units"]["assmilators"] = assimilators
    enemy["P"]["units"]["cybernetics_core"] = cybernetics_core
    enemy["P"]["units"]["citadel_of_adun"] = citadel_of_adun
    enemy["P"]["units"]["stargates"] = stargates
    enemy["P"]["units"]["templar_archives"] = templar_archives
    enemy["T"]["units"]["scvs"] = scvs
    enemy["T"]["units"]["command_centers"] = command_centers 
    enemy["T"]["units"]["supply_depots"] = supply_depots
    enemy["T"]["units"]["refineries"] = refineries
    enemy["T"]["units"]["barracks"] = barracks
    enemy["T"]["units"]["engineering_bay"] = engineering_bay
    enemy["T"]["units"]["missile_turrets"] = missile_turrets
    enemy["T"]["units"]["academy"] = academy
    enemy["T"]["units"]["armory"] = armory
    enemy["T"]["units"]["factories"] = factories
    enemy["T"]["units"]["science_facility"] = science_facility
    enemy["T"]["units"]["starports"] = starports
    enemy["T"]["units"]["bunkers"] = bunkers
    enemy["T"]["units"]["firebats"] = firebats
    enemy["T"]["units"]["goliaths"] = goliaths
    enemy["T"]["units"]["marines"] = marines
    enemy["T"]["units"]["medics"] = medics
    enemy["T"]["units"]["siege_tanks"] = siege_tanks
    enemy["T"]["units"]["tanks"] = tanks
    enemy["T"]["units"]["vultures"] = vultures 
    enemy["T"]["units"]["spider_mines"] = spider_mines
    enemy["T"]["units"]["battlecruisers"] = battlecruisers
    enemy["T"]["units"]["dropships"] = dropships
    enemy["T"]["units"]["science_vessels"] = science_vessels
    enemy["T"]["units"]["valkyries"] = valkyries
    enemy["T"]["units"]["wraiths"] = wraiths
    return enemy
end

function scouting.main_quadrant(pos)
    --
    -- main quadrant
    --
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
    --
    -- position on quadrant
    --
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

function scouting.first_overlord(actions, tc)
    --
    -- first overlord goes to ours enemy's base
    -- missing 12 hatch opening things since depends of 1th overlord (!)
    --
    for uid, ut in pairs(tc.state.units_myself) do
        if ut.type == tc.unittypes.Zerg_Overlord then
            local _, pos = next(tc:filter_type(tc.state.units_myself, 
                {tc.unittypes.Zerg_Hatchery}))
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
                --
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
                --
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
                --
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
        end
    end
    return actions
end

function scouting.second_overlord(ps, uid, ut, actions, tc)
    --
    -- 2th overlord scout go to enemy's natural expansion.
    -- Where is the first zealot going?
    --
    return actions
end

function scouting.eleven_drone_scout(scouting_drones, uid, ut, actions, tc)
    --
    -- eleven drone scout
    --
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
    --
    -- twelve drone scout
    --
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
    --
    -- return main quadrant
    -- 
    return quadrant
end

function scouting.all_quadrants()
    --
    -- return current data on all quadrants
    --
    return quadrants
end

function scouting.lings()
    --
    -- Kill worker scouts and preassure... 
    -- could result in enemy's ore spend on additional defences.
    --
end

function scouting.overlords()
    --
    -- Split overlords after speed upgrade 
    --
end

function scouting.overlord_sacrifice()
    --
    -- How many gates? is there a robotics? 
    --
end

function scouting.scourge_sacrifice()
    --
    -- How many gates? is there a robotics?
    --
end

function scouting.ling_sacrifice()
    --
    -- Live for the Swarm! 
    --
end

function scouting.explore_all_sectors(scouting_drones, uid, ut, actions, tc)
    --
    -- this is not really exploring all 16 sectors
    -- it appears to send a drone to all bases on fs.
    --
    -- check if drone is busy!
    -- check sectors!
    --
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
