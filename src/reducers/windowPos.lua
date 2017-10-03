local setWindowPos = require(script.Parent.Parent.actions.setWindowPos)

return function(state, action)
    state = state or { x = 0, y = 0 }

    if action.type == setWindowPos.name then
        return { x = action.x, y = action.y }
    end

    return state
end