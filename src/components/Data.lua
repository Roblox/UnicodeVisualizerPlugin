local Modules = script.Parent.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local Utf8 = require(Modules.Plugin.Utf8)
local constants = require(Modules.Plugin.Constants)
local Label = require(Modules.Plugin.Components.Label)
local Row = require(Modules.Plugin.Components.Row)

local function Data(props)
	local children = {}

	local legends = { "Offset", "Byte", "Codepoint", "Grapheme Cluster" }
	for i = 1, #legends do
		children['Legend'..legends[i]] = Roact.createElement(Label, {
			x = i, y = 1,
			text = legends[i],
			style = i == 1 and 'LegendLeft' or 'LegendTop',
		})
	end

	local str = props.text
	local spans = Utf8.validSpans(str)
	local codeunits = Utf8.classifyCodeunits(str)
	local codepoints = Utf8.classifyCodepoints(spans)
	local graphemes = Utf8.classifyGraphemes(spans)

	for i = 1, #codeunits do
		children['Codeunit'..i] = Roact.createElement(Row, {
			y = i + 1,
			offset = i,
			value = codeunits[i].value,
			class = codeunits[i].class,
		})
	end

	for i = 1, #codepoints do
		local codepoint = codepoints[i]
		children['Codepoint'..i] = Roact.createElement(Label, {
			x = 3,
			y = codepoint.first + 1,
			h = codepoint.last - codepoint.first + 1,
			text = codepoint.text and string.format("U+%04X %s", codepoint.value, codepoint.text) or "Invalid UTF-8",
			style = 'Codepoint',
			ZIndex = 2,
			selectable = codepoint.value and {
				type = "codepoint",
				id = i,
				code = codepoint.value,
			}
		})
	end

	for i = 1, #graphemes do
		local grapheme = graphemes[i]
		children['Grapheme'..i] = Roact.createElement(Label, {
			x = 4,
			y = grapheme.first + 1,
			h = grapheme.last - grapheme.first + 1,
			text = grapheme.text or "Invalid UTF-8",
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
		ScrollBarThickness = 4,
		BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
		TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
	}, children)
end

local function mapStateToProps(state)
	return {
		text = state.text,
	}
end

Data = RoactRodux.connect(mapStateToProps)(Data)

return Data
