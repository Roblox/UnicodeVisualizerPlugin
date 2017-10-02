local toggleEnabled = require(script.Parent.Parent.actions.toggleEnabled)

return function(state, action)
    state = state == true or false

    if action.type == toggleEnabled.name then
        return not state
    end

    return state
end