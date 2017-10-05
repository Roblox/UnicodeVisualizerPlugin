local action = require(script.Parent.Parent.action)

return action("setText", function(text, confirm)
	return {
		text = text,
		confirm = confirm or false,
	}
end)
