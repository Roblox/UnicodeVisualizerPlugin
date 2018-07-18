local Modules = script.Parent.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local setText = require(Modules.Plugin.Actions.setText)

local function Input(props)
	local len = utf8.len(props.text)
	return Roact.createElement("TextBox", {
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		BackgroundColor3 = len and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 127, 127),
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		BorderSizePixel = 0,
		Font = Enum.Font.SourceSans,
		Text = props.text,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 36,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,

		[Roact.Event.Changed] = function(rbx, prop)
			if prop == 'Text' then
				props.textChanged(rbx.Text)
			end
		end,

		[Roact.Event.FocusLost] = function(rbx, enterPressed)
			if enterPressed then
				props.textChanged(rbx.Text, true)
			end
		end,

		[Roact.Event.InputBegan] = function(rbx, input)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				props.textChanged("")
			end
		end,
	})
end

Input = RoactRodux.connect(function(store)
	local state = store:getState()

	return {
		text = state.text,
		textChanged = function(text, confirm)
			store:dispatch(setText(text, confirm))
		end
	}
end)(Input)

return Input
