local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local setText = require(Modules.actions.setText)

local constants = require(Modules.constants)

local function Input(props)
	return Roact.createElement("TextBox", {
		LayoutOrder = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 50),
		ZIndex = 2,
		Font = Enum.Font.SourceSans,
		Text = props.text,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 36,
		ClearTextOnFocus = false,

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
	local state = store:GetState()

	return {
		text = state.text,
		textChanged = function(text, confirm)
			store:Dispatch(setText(text, confirm))
		end
	}
end)(Input)

return Input