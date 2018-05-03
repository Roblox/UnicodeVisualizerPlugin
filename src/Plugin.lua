return function(plugin, initialState)
	local CoreGui = game:GetService("CoreGui")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local HttpService = game:GetService("HttpService")

	local Modules = script.Parent

	local Roact = require(Modules.Roact)
	local Rodux = require(Modules.Rodux)
	local RoactRodux = require(Modules.RoactRodux)

	local App = require(script.Parent.components.App)
	local reducer = require(script.Parent.reducers.root)

	local toolbar = plugin:toolbar("Unicode")

	local toggleButton = plugin:button(
		toolbar,
		"Visualizer",
		"View the details of any Unicode string",
		"rbxassetid://1062292973"
	)

	local pluginGui = plugin:createDockWidgetPluginGui("UnicodeVisualizer", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 800, 600, 400, 200))
	pluginGui.Name = "UnicodeVisualizer"
	pluginGui.Title = "Unicode Visualizer"
	pluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local store = Rodux.Store.new(reducer, initialState)

	local element = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App)
	})

	local connection = toggleButton.Click:Connect(function()
		pluginGui.Enabled = not pluginGui.Enabled
	end)

	local instance = Roact.reify(element, pluginGui, "UnicodeVisualizer")

	plugin:beforeUnload(function()
		local saveState = store:getState()
		connection:Disconnect()
		Roact.teardown(instance)
		return saveState
	end)
end