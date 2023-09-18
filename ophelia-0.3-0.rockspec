package = "ophelia"
version = "0.3-0"
source = {
  url = "git://github.com/spacebeam/ophelia",
  tag = "0.3.0",
}

description = {
  summary = "I am so tired of her schemes. And now, this ridiculous plan.",
  detailed = "We don't know where she is from, or even what strain she is.",
  homepage = "https://spacebeam.org",
  license = "APACHE 2"
}

dependencies = {
  "lua == 5.1",
  "luasocket",
  "lzmq-ffi",
  "inspect",
  "luasec",
  "turbo",
  "uuid",
}