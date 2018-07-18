local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)

local MainFrame = require(Modules.components.MainFrame)
local Tooltip = require(Modules.components.Tooltip)

local function App(props)
	return Roact.createElement("Folder", nil, {
		Main = Roact.createElement(MainFrame),
		Tooltip = Roact.createElement(Tooltip),
	})
end

return App
