local action = require(script.Parent.Parent.action)

return action("importStrings", function(strings)
	return {
		strings = strings,
	}
end)
