local Modules = script.Parent.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local Input = require(Modules.Plugin.Components.Input)
local Data = require(Modules.Plugin.Components.Data)
local Info = require(Modules.Plugin.Components.Info)
local PickerMenu = require(Modules.Plugin.Components.PickerMenu)

local function MainFrame(props)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Active = true,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, {
		InputFrame = Roact.createElement("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1.0,
			ZIndex = 2,
		}, {
			Input = Roact.createElement(Input, {
				Position = UDim2.new(0, 7, 0, 7),
				Size = UDim2.new(1, -30, 1, -14),
			}),
			Picker = Roact.createElement(PickerMenu, {
				Position = UDim2.new(1, -6, 0, 6),
				AnchorPoint = Vector2.new(1, 0),
			}),
		}),
		Body = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, -50),
			Position = UDim2.new(0, 0, 0, 50),
			BackgroundTransparency = 1.0,
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
			}),
			Data = Roact.createElement(Data, {
				Size = props.selected and UDim2.new(1, -250, 1, 0) or UDim2.new(1, 0, 1, 0),
			}),
			Info = Roact.createElement(Info, {
				Size = props.selected and UDim2.new(0, 250, 1, 0) or UDim2.new(0, 0, 0, 0),
			}),
		})
	})
end

local function mapStateToProps(state)
	return {
		selected = state.selected,
	}
end

MainFrame = RoactRodux.connect(mapStateToProps)(MainFrame)

return MainFrame
