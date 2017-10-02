local enabled = require(script.Parent.enabled)
local text = require(script.Parent.text)
local selected = require(script.Parent.selected)

return function(state, action)
    state = state or {}

    return {
        enabled = enabled(state.enabled, action),
        text = text(state.text, action),
        selected = selected(state.selected, action),
    }
end
