local setTooltip = require(script.Parent.Parent.actions.setTooltip)

return function(state, action)
	state = state or nil

	if action.type == setTooltip.name then
		return action.text
	end

	return state
end
