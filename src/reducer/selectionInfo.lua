local function selectionInfo(state, selected, action)
	state = state or nil

	if action.type == 'setSelectionInfo' and action.of == selected then
		return action.what
	end

	return state
end

return selectionInfo
