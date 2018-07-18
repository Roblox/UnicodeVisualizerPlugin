local function text(state, action)
	state = state or ""

	if action.type == 'setText' then
		return action.text
	end

	return state
end

return text
