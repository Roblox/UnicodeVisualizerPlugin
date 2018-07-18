local text = require(script.text)
local selected = require(script.selected)
local selectionInfo = require(script.selectionInfo)
local tooltip = require(script.tooltip)
local recentlyUsed = require(script.recentlyUsed)
local importStrings = require(script.importStrings)

local function reducer(state, action)
	state = state or {}

	return {
		text = text(state.text, action),
		selected = selected(state.selected, action),
		selectionInfo = selectionInfo(state.selectionInfo, state.selected, action),
		tooltip = tooltip(state.tooltip, action),
		recentlyUsed = recentlyUsed(state.recentlyUsed, action),
		importStrings = importStrings(state.importStrings, action),
	}
end

return reducer
