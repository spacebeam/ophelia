local TimingSystem = tiny.processingSystem(class("TimingSystem"))

TimingSystem.filter = tiny.requireAll("timing")

function TimingSystem:process(e, dt)
    e.timing = e.timing - dt
    if e.timing <= 0 then
        if e.onTime then
            e:onTime()
        end
        world:remove(e)
    end
end

return TimingSystem
