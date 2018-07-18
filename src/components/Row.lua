local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)
local constants = require(Modules.constants)
local Label = require(Modules.components.Label)
local CodeunitClass = require(Modules.Utf8).CodeunitClass

local function Row(props)
	local color
	local tooltip

	local class = props.class
	if class == CodeunitClass.Single then
		color = constants.UTF1BYTE
		tooltip = "Single-byte sequence"
	elseif class == CodeunitClass.Continuation then
		color = constants.UTFCONT
		tooltip = "Continuation byte"
	elseif class == CodeunitClass.Start2 then
		color = constants.UTF2BYTE
		tooltip = "2-byte sequence start"
	elseif class == CodeunitClass.Start3 then
		color = constants.UTF3BYTE
		tooltip = "3-byte sequence start"
	elseif class == CodeunitClass.Start4 then
		color = constants.UTF4BYTE
		tooltip = "4-byte sequence start"
	else
		color = constants.INVALID
		tooltip = "Invalid UTF-8"
	end

	local y = props.y
	local pos = constants.YOFF + (y - 2) * constants.ROW + (y - 1) * constants.PAD - constants.HALFPAD + constants.MARGIN

	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(127, 127, 127),
		BackgroundTransparency = props.y % 2 == 0 and 0.75 or 1.0,

		Position = UDim2.new(0, 0, 0, pos),
		Size = UDim2.new(1, 0, 0, constants.ROW + constants.HALFPAD*2),
	}, {
		Offset = Roact.createElement(Label, {
			x = 1,
			style = 'LegendLeft',
			text = string.format("%d", props.offset),
		}),
		Byte = Roact.createElement(Label, {
			x = 2,
			style = 'Byte',
			text = string.format("%02X", props.value),
			BackgroundColor3 = color,
			tooltip = tooltip,
		})
	})
end

return Row
