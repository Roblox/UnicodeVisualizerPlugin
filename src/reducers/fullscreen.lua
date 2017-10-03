local toggleFullscreen = require(script.Parent.Parent.actions.toggleFullscreen)

return function(state, action)
    state = state == nil and true or state

    if action.type == toggleFullscreen.name then
        return not state
    end

    return state
end