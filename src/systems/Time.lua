local TimeSystem = tiny.processingSystem(class("TimeSystem"))

TimeSystem.filter = tiny.requireAll("time")

function TimeSystem:process(e, dt)
    e.time = e.time - dt
    if e.time <= 0 then
        if e.onTime then
            e:onTime()
        end
        world:remove(e)
    end
end

return TimeSystem
