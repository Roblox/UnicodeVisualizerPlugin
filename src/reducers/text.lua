local setText = require(script.Parent.Parent.actions.setText)

return function(state, action)
	state = state or ""

	if action.type == setText.name then
		return action.text
	end

	return state
end
