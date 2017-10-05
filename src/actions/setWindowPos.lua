local action = require(script.Parent.Parent.action)

return action("setWindowPos", function(pos)
	return {
		x = pos.x,
		y = pos.y,
	}
end)
