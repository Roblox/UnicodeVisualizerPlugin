local function selected(state, action)
	state = state or nil

	if action.type == 'setSelection' then
		return action.what
	end

	return state
end

return selected
