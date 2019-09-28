-- I hear thunder but there's no rain

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
  "moses",
  "inspect",
  "uuid"
}

build = {
  type = 'builtin',
  modules = {
    ['ophelia.lib.json'] = "src/lib/json.lua",
    ['ophelia.lib.star'] = "src/lib/lua-star.lua",
    ['ophelia.lib.yaml'] = "src/lib/YAMLParserLite.lua",
    ['ophelia.counters'] = "src/counters.lua",
    ['ophelia.economy'] = "src/economy.lua",
    ['ophelia.openings'] = "src/openings.lua",
    ['ophelia.scouting'] = "src/scouting.lua",
    ['ophelia.tactics'] = "src/tactics.lua",
    ['ophelia.tools'] = "src/tools.lua",
    ['ophelia.zstreams'] = "src/zstreams.lua"
  },
  install = {
    bin = {
      ['ophelia'] = "src/main.lua"
    }
  }
}
