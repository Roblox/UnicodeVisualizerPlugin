local function importStrings(state, action)
	state = state or {}

	if action.type == 'importStrings' then
		return action.strings
	end

	return state
end

return importStrings
