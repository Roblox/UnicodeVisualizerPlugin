local enabled = require(script.Parent.enabled)
local text = require(script.Parent.text)
local selected = require(script.Parent.selected)
local fullscreen = require(script.Parent.fullscreen)
local windowPos = require(script.Parent.windowPos)
local windowSize = require(script.Parent.windowSize)
local tooltip = require(script.Parent.tooltip)
local recentlyUsed = require(script.Parent.recentlyUsed)

return function(state, action)
	state = state or {}

	return {
		enabled = enabled(state.enabled, action),
		text = text(state.text, action),
		selected = selected(state.selected, action),
		fullscreen = fullscreen(state.fullscreen, action),
		windowPos = windowPos(state.windowPos, action),
		windowSize = windowSize(state.windowSize, action),
		tooltip = tooltip(state.tooltip, action),
		recentlyUsed = recentlyUsed(state.recentlyUsed, action),
	}
end
