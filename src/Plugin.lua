return function(plugin)
	local CoreGui = game:GetService("CoreGui")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local HttpService = game:GetService("HttpService")

	local Common = script.Parent.Common

	local Roact = require(Common.Roact)
	local Rodux = require(Common.Rodux)
	local RoactRodux = require(Common.RoactRodux)

	local App = require(script.Parent.components.App)
	local reducer = require(script.Parent.reducers.root)
	local toggleEnabled = require(script.Parent.actions.toggleEnabled)

	local toolbar = plugin:toolbar("Unicode")

	local toggleButton = plugin:button(
		toolbar,
        "Visualizer",
        "View the details of any Unicode string",
        "rbxassetid://1062292973"
	)

	local initialState do
		local save = ReplicatedStorage:FindFirstChild("StoreState")
		if save then
			initialState = HttpService:JSONDecode(save.Value)
		end
	end

	local store = Rodux.Store.new(reducer, initialState)

	local connection = toggleButton.Click:Connect(function()
		store:Dispatch(toggleEnabled())
	end)

	local element = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App)
	})

	local instance = Roact.reify(element, CoreGui, "UnicodeVisualizer")

	plugin:beforeUnload(function()
		local save = ReplicatedStorage:FindFirstChild("StoreState")
		if not save then
			save = Instance.new("StringValue")
			save.Name = "StoreState"
			save.Parent = ReplicatedStorage
		end
		save.Value = HttpService:JSONEncode(store:GetState())
		connection:Disconnect()
		Roact.teardown(instance)
	end)
end