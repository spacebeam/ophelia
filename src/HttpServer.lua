-- internet things

local turbo = require("turbo")

local HelloWorldHandler = class("HelloWorldHandler", turbo.web.RequestHandler)

function HelloWorldHandler:get()
    self:write("Hello World!")
end

turbo.web.Application({
    {"/", HelloWorldHandler}
}):listen(9374)
turbo.ioloop.instance():start()
