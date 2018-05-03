local importStrings = require(script.Parent.Parent.actions.importStrings)

return function(state, action)
	state = state or {}

	if action.type == importStrings.name then
		return action.strings
	end

	return state
end
