local function recentlyUsed(state, action)
	state = state or {}

	if action.type == 'setText' and action.confirm then
		local new = {}
		new[1] = action.text
		for i = 1, math.min(#state, 9) do
			if state[i] ~= action.text then
				new[#new+1] = state[i]
			end
		end
		return new
	end

	return state
end

return recentlyUsed
