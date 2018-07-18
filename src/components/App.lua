local Modules = script.Parent.Parent.Parent

local Roact = require(Modules.Roact)
local MainFrame = require(Modules.Plugin.Components.MainFrame)
local Tooltip = require(Modules.Plugin.Components.Tooltip)

local function App(props)
	return Roact.createElement("Folder", nil, {
		Main = Roact.createElement(MainFrame),
		Tooltip = Roact.createElement(Tooltip),
	})
end

return App
