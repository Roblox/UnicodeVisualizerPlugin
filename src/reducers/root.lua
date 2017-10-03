local enabled = require(script.Parent.enabled)
local text = require(script.Parent.text)
local selected = require(script.Parent.selected)
local fullscreen = require(script.Parent.fullscreen)
local windowPos = require(script.Parent.windowPos)
local windowSize = require(script.Parent.windowSize)

return function(state, action)
    state = state or {}

    return {
        enabled = enabled(state.enabled, action),
        text = text(state.text, action),
        selected = selected(state.selected, action),
        fullscreen = fullscreen(state.fullscreen, action),
        windowPos = windowPos(state.windowPos, action),
        windowSize = windowSize(state.windowSize, action),
    }
end
