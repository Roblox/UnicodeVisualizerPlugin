local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local setText = require(Modules.actions.setText)
local constants = require(Modules.constants)

local PickerMenu = Roact.Component:extend("PickerMenu")

function Header(props)
	return Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = props.LayoutOrder,
		Text = props.Text,
		BackgroundTransparency = 0.0,
		BackgroundColor3 = Color3.fromRGB(235, 235, 220),
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		TextSize = 18,
	})
end

function Entry(props)
	return Roact.createElement("TextButton", {
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = props.LayoutOrder,
		Text = props.Text,
		BackgroundTransparency = 0.0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		TextSize = 18,

		[Roact.Event.MouseButton1Click] = function(rbx)
			props.setText(rbx.Text)
		end,
	})
end

function PickerMenu:render()
	local props = self.props

	local function setText(text)
		self:setState({
			open = false,
		})
		props.setText(text)
	end

	local children = {}
	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 1),
	})
	children[#children+1] = Roact.createElement(Header, {
		Text = "Recently Used",
		LayoutOrder = #children,
		setText = setText,
	})
	for i = 1, #props.recentlyUsed do
		children[#children+1] = Roact.createElement(Entry, {
			Text = props.recentlyUsed[i],
			LayoutOrder = #children,
			setText = setText,
		})
	end
	children[#children+1] = Roact.createElement(Header, {
		Text = "Selected Instances",
		LayoutOrder = #children,
		setText = setText,
	})
	for i = 1, #props.importStrings do
		children[#children+1] = Roact.createElement(Entry, {
			Text = props.importStrings[i],
			LayoutOrder = #children,
			setText = setText,
		})
	end
	children[#children+1] = Roact.createElement(Header, {
		Text = "Examples",
		LayoutOrder = #children,
		setText = setText,
	})
	local examples = constants.Examples
	for i = 1, #examples do
		children[#children+1] = Roact.createElement(Entry, {
			Text = examples[i],
			LayoutOrder = #children,
			setText = setText,
		})
	end

	local borderColor = Color3.fromRGB(200, 200, 200)
	return Roact.createElement("ImageButton", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		BackgroundTransparency = 1.0,
		Size = UDim2.new(0, 16, 0, 16),
		Image = "http://www.roblox.com/asset/?id=1083248618",

		[Roact.Event.MouseButton1Click] = function(rbx)
			self:setState({
				open = not self.state.open
			})
		end,
	}, {
		InputCapture = Roact.createElement("ImageButton", {
			Position = UDim2.new(0, -5000, 0, -5000),
			Size = UDim2.new(1, 10000, 1, 10000),
			BackgroundTransparency = 1.0,
			Visible = self.state.open,

			[Roact.Event.MouseButton1Click] = function(rbx)
				self:setState({
					open = false
				})
			end,
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 5000),
				PaddingRight = UDim.new(0, 5000),
				PaddingTop = UDim.new(0, 5000),
				PaddingBottom = UDim.new(0, 5000),
			}),
			Menu = Roact.createElement("Frame", {
				Position = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 150, 0, #children * 21 - 1),
				BackgroundColor3 = borderColor,
				BorderColor3 = borderColor,
				ClipsDescendants = true,
			}, children),
		})
	})
end

function PickerMenu:init()
	self.state = {
		open = false,
	}
end

PickerMenu = RoactRodux.connect(function(store)
	local state = store:getState()

	return {
		recentlyUsed = state.recentlyUsed,
		importStrings = state.importStrings,
		setText = function(text)
			store:dispatch(setText(text))
		end,
	}
end)(PickerMenu)

return PickerMenu
