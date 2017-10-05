local action = require(script.Parent.Parent.action)

return action("setTooltip", function(text)
	return {
		text = text,
	}
end)
