return function(state, action)
	state = state or nil

	if action.type == 'setTooltip' then
		return action.text
	end

	return state
end
