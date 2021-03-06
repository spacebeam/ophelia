package = "ophelia"
version = "0.1-0"
source = {
  url = "git://github.com/spacebeam/ophelia",
  tag = "0.1.0",
}

description = {
  summary = "I am so tired of her schemes. And now, this ridiculous plan.",
  detailed = "We don't know where she is from, or even what strain she is.",
  homepage = "https://spacebeam.org",
  license = "AGPL 3"
}

dependencies = {
  "lua == 5.1",
  "argparse",
  "luasocket",
  "lzmq-ffi",
  "middleclass",
  "tiny-ecs",
  "inspect",
  "uuid",
  "fun",
}

build = {
  type = 'builtin',
  modules = {
    ['ophelia.lib.json'] = "src/lib/JSON.lua",
    ['ophelia.lib.vector'] = "src/lib/vector.lua",
    ['ophelia.lib.yaml'] = "src/lib/YAMLParserLite.lua",
    ['ophelia.economy'] = "src/game/economy.lua",
    ['ophelia.openings'] = "src/game/openings.lua",
    ['ophelia.scouting'] = "src/game/scouting.lua",
    ['ophelia.tactics'] = "src/game/tactics.lua",
    ['ophelia.tools'] = "src/tools.lua",
  },
  install = {
    bin = {
      ['ophelia'] = "src/main.lua"
    }
  }
}