local action = require(script.Parent.Parent.action)

return action("select", function(what)
	return {
        what = what,
    }
end)
