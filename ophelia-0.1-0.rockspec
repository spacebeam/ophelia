package = "ophelia"
version = "0.1-0"

source = {
  url = "git://github.com/spacebeam/ophelia",
  tag = "0.1.0",
}

description = {
  summary = "I am so tired of her schemes. And now, this ridiculous plan.",
  detailed = "We don't know where she is from, or even what strain she is.",
  homepage = "https://spacebeam.io",
  license = "AGPL 3"
}

dependencies = {
  "lua == 5.1",
  "argparse",
  "luasocket",
  "lzmq-ffi",
  "uuid"
}

build = {
  type = 'builtin',
  modules = {
    ['ophelia.macro'] = "src/macro.lua",
    ['ophelia.micro'] = "src/micro.lua",
    ['ophelia.tools'] = "src/tools.lua"
  },
  install = {
    bin = {
      ['ophelia'] = "src/main.lua"
    }
  }
}
