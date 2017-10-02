local action = require(script.Parent.Parent.action)

return action("setText", function(text)
	return {
        text = text,
    }
end)
