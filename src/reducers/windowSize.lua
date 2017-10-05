local constants = require(script.Parent.Parent.constants)
local setWindowSize = require(script.Parent.Parent.actions.setWindowSize)

return function(state, action)
	state = state or {
		x = constants.DEFAULT_WINDOW_SIZE.x,
		y = constants.DEFAULT_WINDOW_SIZE.y
	}

	if action.type == setWindowSize.name then
		return {
			x = math.max(constants.MIN_WINDOW_SIZE.x, action.x),
			y = math.max(constants.MIN_WINDOW_SIZE.y, action.y)
		}
	end

	return state
end