return function(plugin, initialState)
	local Selection = game:GetService("Selection")

	local Modules = script.Parent

	local Roact = require(Modules.Roact)
	local Rodux = require(Modules.Rodux)
	local RoactRodux = require(Modules.RoactRodux)

	local App = require(script.Parent.components.App)
	local reducer = require(script.Parent.reducers.root)
	local importStrings = require(script.Parent.actions.importStrings)

	local toolbar = plugin:toolbar("Unicode")

	local toggleButton = plugin:button(
		toolbar,
		"Visualizer",
		"View the details of any Unicode string",
		"rbxassetid://1062292973"
	)

	local dockInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 800, 600, 500, 200)
	local pluginGui = plugin:createDockWidgetPluginGui("UnicodeVisualizer", dockInfo)
	pluginGui.Name = "UnicodeVisualizer"
	pluginGui.Title = "Unicode Visualizer"
	pluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local store = Rodux.Store.new(reducer, initialState, { Rodux.thunkMiddleware })

	local element = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App)
	})

	local connection = toggleButton.Click:Connect(function()
		pluginGui.Enabled = not pluginGui.Enabled
	end)

	local instance = Roact.reify(element, pluginGui, "UnicodeVisualizer")

	local changedConns = {}
	local function disconnectSelectionChangedConns()
		for _,conn in pairs(changedConns) do
			conn:Disconnect()
		end
		changedConns = {}
	end
	local function updateStringList()
		local sel = Selection:Get()
		local stringsMap = {}
		local stringProps = {
			"Name",
			"Text",
			"LocalizedText",
			"PlaceholderText",
			"Value",
			"Title",
			"Tooltip"
		}

		for i = 1, #sel do
			for _,prop in pairs(stringProps) do
				local ok, value = pcall(function()
					return sel[i][prop]
				end)
				if ok and typeof(value) == 'string' then
					stringsMap[value] = true
				end
			end
		end

		local strings = {}
		for key,_ in pairs(stringsMap) do
			strings[#strings+1] = key
		end
		table.sort(strings)
		store:dispatch(importStrings(strings))
	end
	local function onSelectionChanged()
		disconnectSelectionChangedConns()

		local sel = Selection:Get()

		for i = 1, #sel do
			changedConns[i] = sel[i].Changed:Connect(updateStringList)
		end
		updateStringList()
	end
	local selectionChanged = Selection.SelectionChanged:Connect(onSelectionChanged)
	onSelectionChanged()

	plugin:beforeUnload(function()
		local saveState = store:getState()
		connection:Disconnect()
		Roact.teardown(instance)
		disconnectSelectionChangedConns()
		selectionChanged:Disconnect()
		return saveState
	end)
end
