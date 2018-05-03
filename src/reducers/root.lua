local text = require(script.Parent.text)
local selected = require(script.Parent.selected)
local tooltip = require(script.Parent.tooltip)
local recentlyUsed = require(script.Parent.recentlyUsed)

return function(state, action)
	state = state or {}

	return {
		text = text(state.text, action),
		selected = selected(state.selected, action),
		tooltip = tooltip(state.tooltip, action),
		recentlyUsed = recentlyUsed(state.recentlyUsed, action),
	}
end
