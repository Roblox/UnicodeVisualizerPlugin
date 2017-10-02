local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)

local constants = require(Modules.constants)

local Input = require(Modules.components.Input)
local Data = require(Modules.components.Data)

local function MainFrame(props)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(83, 83, 83),
		BorderSizePixel = 0,
	}, {
		Input = Roact.createElement(Input),
		Data = Roact.createElement(Data),
		Close = Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1.0,
			Position = UDim2.new(1, -2, 0, 2),
			Size = UDim2.new(0, 25, 0, 25),
			ZIndex = 3,
			Image = "rbxasset://textures/ui/Keyboard/close_button_icon.png",
		}),
	})
end

return MainFrame