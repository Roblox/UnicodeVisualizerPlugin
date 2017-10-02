local Modules = script.Parent.Parent

local Common = Modules.Common

local Roact = require(Common.Roact)
local RoactRodux = require(Common.RoactRodux)

local MainFrame = require(Modules.components.MainFrame)

local function App(props)
	local enabled = props.enabled

	if enabled then
		return Roact.createElement("ScreenGui", nil, {
			Main = Roact.createElement(MainFrame),
		})
	else
		return nil
	end
end

App = RoactRodux.connect(function(store)
	local state = store:GetState()

	return {
		enabled = state.enabled,
	}
end)(App)

return App
