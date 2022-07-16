local Update = tiny.processingSystem(class("Update"))

Update.filter = tiny.requireAll("update")

function Update:process(e, dt)
	e:update(dt)
end

return Update
