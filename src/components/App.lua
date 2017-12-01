local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local MainFrame = require(Modules.components.MainFrame)
local Tooltip = require(Modules.components.Tooltip)

local function App(props)
	local enabled = props.enabled

	if enabled then
		return Roact.createElement("ScreenGui", nil, {
			Main = Roact.createElement(MainFrame),
			Tooltip = Roact.createElement(Tooltip),
		})
	else
		return nil
	end
end

App = RoactRodux.connect(function(store)
	local state = store:getState()

	return {
		enabled = state.enabled,
	}
end)(App)

return App
