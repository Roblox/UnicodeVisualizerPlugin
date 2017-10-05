local select = require(script.Parent.Parent.actions.select)

return function(state, action)
	state = state or nil

	if action.type == select.name then
		return action.what
	end

	return state
end
