local TextService = game:GetService("TextService")

local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local setText = require(Modules.actions.setText)

local constants = require(Modules.constants)

local function InfoPage(props)
	local children = {}
	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	children.UIPadding = Roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 5),
		PaddingTop = UDim.new(0, 5),
	})

	-- padding etc
	local textWidth = constants.PANEL_WIDTH - 5
	local textFrame = Vector2.new(textWidth, 10000)

	local style = constants.InfoBox

	local height = 0
	for i = 1, #props.nodes do
		local node = props.nodes[i]
		local inst
		local h = 0
		if node.type == 'Header' then
			local size = style.headingSizes[node.heading or 1]
			local text = node.text
			local font = style.headingFonts[node.heading or 1]
			local bounds = TextService:GetTextSize(text, size, font, textFrame)
			h = bounds.y + 16
			inst = Roact.createElement("TextLabel", {
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, h),

				Text = text,
				Font = font,
				TextSize = size,

				TextWrapped = true,
				BackgroundTransparency = 1.0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = style.textColor,
			})
		elseif node.type == 'Paragraph' then
			local size = style.textSize
			local text = string.format("\t%s", node.text)
			local font = style.textFont
			local bounds = TextService:GetTextSize(text, size, font, textFrame)
			h = bounds.y
			inst = Roact.createElement("TextLabel", {
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, h),

				Text = text,
				TextSize = size,
				Font = font,

				TextWrapped = true,
				BackgroundTransparency = 1.0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = style.textColor,
			})
		elseif node.type == 'ListItem' then
			local text = ('\t'):rep(node.indent or 1) .. style.bullets[node.indent or 1] .. ' ' .. node.text
			local size = style.textSize
			local font = style.textFont
			local bounds = TextService:GetTextSize(text, size, font, textFrame)
			h = bounds.y
			inst = Roact.createElement("TextLabel", {
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, h),

				Text = text,
				TextSize = size,
				Font = font,

				TextWrapped = true,
				BackgroundTransparency = 1.0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = style.textColor,
			})
		elseif node.type == 'Table' then
			h = #node.rows * 20
			local children = {}
			children.UITableLayout = Roact.createElement("UITableLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillEmptySpaceColumns = true,
				FillEmptySpaceRows = true,
				Padding = UDim2.new(0, 1, 0, 1),
			})
			children.UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, style.tableInset),
				PaddingRight = UDim.new(0, style.tableInset),
			})
			for y = 1, #node.rows do
				local row = node.rows[y]
				local rowChildren = {}
				for x = 1, #row do
					local bounds = TextService:GetTextSize(tostring(row[x]), style.textSize, style.textFont, Vector2.new(400, 400))
					rowChildren[x] = Roact.createElement("TextLabel", {
						LayoutOrder = x,
						Size = UDim2.new(0, 30, 0, 20),
						BackgroundColor3 = Color3.fromRGB(60, 60, 60),
						BorderColor3 = Color3.fromRGB(127, 127, 127),
						Text = tostring(row[x]),
						TextSize = style.textSize,
						Font = style.textFont,
						TextColor3 = style.textColor,
					}, {
						UISizeConstraint = Roact.createElement("UISizeConstraint", {
							MaxSize = bounds + Vector2.new(style.tablePad, style.tablePad) * 2,
						})
					})
				end
				children[#children+1] = Roact.createElement("Frame", {
					LayoutOrder = y,
					BackgroundTransparency = 1.0,
				}, rowChildren)
			end

			inst = Roact.createElement("Frame", {
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, h),
				BackgroundTransparency = 1.0,
			}, children)
		else
			error(string.format("Unknown markup node %s", tostring(node.type)))
		end
		children[node.type .. i] = inst
		height = height + h
	end

	return Roact.createElement("ScrollingFrame", {
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Size = props.Size,
		CanvasSize = UDim2.new(0, 0, 0, height + 10),
		BorderSizePixel = 0,
	}, children)
end

return InfoPage