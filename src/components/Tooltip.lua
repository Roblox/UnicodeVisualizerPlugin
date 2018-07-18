local Modules = script.Parent.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local function Tooltip(props)
	local tooltip = props.tooltip

	local size = 20
	local font = Enum.Font.SourceSans
	local TextService = game:GetService("TextService")
	local bounds = TextService:GetTextSize(tooltip or "", size, font, Vector2.new(200, 400))
	return Roact.createElement("TextLabel", {
		Text = tooltip or "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		Visible = tooltip ~= nil,
		TextSize = size,
		Font = font,
		Size = UDim2.new(0, bounds.x + 16, 0, bounds.y + 16),
		Position = UDim2.new(1, -16, 1, -16),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 240),
	})
end

local function mapStateToProps(state)
	return {
		tooltip = state.tooltip,
	}
end

Tooltip = RoactRodux.connect(mapStateToProps)(Tooltip)

return Tooltip
