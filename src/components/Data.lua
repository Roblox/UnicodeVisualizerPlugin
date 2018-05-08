local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

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

	local spans = {}
	local spanstarts = {}
	local offset = 1
	local errstart = nil
	while offset <= #str do
		local len, errp = utf8.len(str, offset)
		if len then
			if errstart then
				children[#children+1] = Roact.createElement(Label, {
					x = 3,
					y = errstart + 1,
					h = offset - errstart,
					text = string.format("Invalid UTF-8"),
					style = 'CodepointError',
					ZIndex = 2,
				})
			end
			spans[#spans+1] = str:sub(offset, #str)
			spanstarts[#spanstarts+1] = offset - 1
			break
		else
			if not errstart then
				if errp - offset > 0 then
					spans[#spans+1] = str:sub(offset, offset + errp - 1)
					spanstarts[#spanstarts+1] = offset - 1
				end
				errstart = offset + errp - 1
			end
			offset = errp + 1
		end
	end

	for i = 1, #spans do
		local span = spans[i]
		local start = spanstarts[i]

		local len = utf8.len(span)
		for p,code in utf8.codes(span) do
			local char = utf8.char(code)
			children[#children+1] = Roact.createElement(Label, {
				x = 3,
				y = start + p + 1,
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
		for first, last in utf8.graphemes(span) do
			local char = span:sub(first, last)
			children[#children+1] = Roact.createElement(Label, {
				x = 4,
				y = start + first + 1,
				h = last - first + 1,
				text = string.format("%s", char),
				style = 'Grapheme',
				ZIndex = 2,
			})
		end
	end

	return Roact.createElement("ScrollingFrame", {
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 0,
		Size = props.Size,
		CanvasSize = UDim2.new(0, 0, 0, (#str + 1) * (constants.ROW + constants.PAD) + 2 * constants.MARGIN),
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
		ScrollBarThickness = 4,
		BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
		TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
	}, children)
end

Data = RoactRodux.connect(function(store)
	local state = store:getState()

	return {
		text = state.text,
	}
end)(Data)

return Data