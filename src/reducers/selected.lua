return function(state, action)
	state = state or nil

	if action.type == 'select' then
		return action.what
	end

	return state
end
