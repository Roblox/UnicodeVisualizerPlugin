local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)

local constants = require(Modules.constants)
local Label = require(Modules.components.Label)
local Row = require(Modules.components.Row)

local function Data(props)
	local children = {}

	local str = props.text

	local legends = { "Offset", "Byte", "Codepoint", "Grapheme Cluster" }
	for i = 1, #legends do
		children[#children+1] = Roact.createElement(Label, {
			x = i, y = 1,
			text = legends[i],
			style = i == 1 and 'LegendLeft' or 'LegendTop',
		})
	end

	for i = 1, #str do
		children[#children+1] = Roact.createElement(Row, {
			y = i + 1,
			offset = i,
			byte = str:byte(i),
		})
	end

	for p,code in utf8.codes(str) do
		local char = utf8.char(code)
		children[#children+1] = Roact.createElement(Label, {
			x = 3,
			y = p + 1,
			h = #char,
			text = string.format("U+%04X %s", code, char),
			style = 'Codepoint',
			ZIndex = 2,
			selectable = {
				type = "codepoint",
				id = p,
				code = code,
			}
		})
	end

	for first, last in utf8.graphemes(str) do
		local char = str:sub(first, last)
		children[#children+1] = Roact.createElement(Label, {
			x = 4,
			y = first + 1,
			h = last - first + 1,
			text = string.format("%s", char),
			style = 'Grapheme',
			ZIndex = 2,
		})
	end

	return Roact.createElement("ScrollingFrame", {
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 0,
		Size = props.Size,
		CanvasSize = UDim2.new(0, 0, 0, (#str + 1) * (constants.ROW + constants.PAD) + 2 * constants.MARGIN),
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
	}, children)
end

Data = RoactRodux.connect(function(store)
	local state = store:GetState()

	return {
		text = state.text,
	}
end)(Data)

return Data