local action = require(script.Parent.Parent.action)

return action("setWindowSize", function(size)
	return {
		x = size.x,
		y = size.y,
	}
end)
