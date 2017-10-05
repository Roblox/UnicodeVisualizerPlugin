local Modules = script.Parent.Parent

local Common = Modules.Common

local Roact = require(Common.Roact)
local RoactRodux = require(Common.RoactRodux)

local Tooltip = Roact.Component:extend("Tooltip")

function Tooltip:render()
	local props = self.props
	local tooltip = props.tooltip

	if tooltip then
		local size = 20
		local font = Enum.Font.SourceSans
		local TextService = game:GetService("TextService")
		local bounds = TextService:GetTextSize(tooltip, size, font, Vector2.new(200, 400))
		return Roact.createElement("TextLabel", {
			Text = tooltip,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = size,
			Font = font,
			Size = UDim2.new(0, bounds.x + 16, 0, bounds.y + 16),
			Position = UDim2.new(0, self.state.x + 16, 0, self.state.y),
			BackgroundColor3 = Color3.fromRGB(255, 255, 240),
			ZIndex = 10,
		})
	else
		return nil
	end
end

function Tooltip:init()
	self.state = {
		x = 0,
		y = 0
	}
end

function Tooltip:didMount()
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	self.conn = RunService.Heartbeat:Connect(function()
		local inset = GuiService:GetGuiInset()
		local mouse = UserInputService:GetMouseLocation() - inset
		self:setState({
			x = mouse.X,
			y = mouse.Y,
		})
	end)
end

function Tooltip:willUnmount()
	self.conn:Disconnect()
end

Tooltip = RoactRodux.connect(function(store)
	local state = store:GetState()

	return {
		tooltip = state.tooltip,
	}
end)(Tooltip)

return Tooltip
