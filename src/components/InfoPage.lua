local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local setText = require(Modules.actions.setText)

local constants = require(Modules.constants)

local function InfoPage(props)
    local children = {}
    children[1] = Roact.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    children[2] = Roact.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
    })

    local style = constants.InfoBox

    local height = 0
    for i = 1, #props.nodes do
        local node = props.nodes[i]
        local inst
        local h = 0
        if node.type == 'Header' then
            h = style.headingSizes[node.heading or 1] + 16
            inst = Roact.createElement("TextLabel", {
                LayoutOrder = i,
                BackgroundTransparency = 1.0,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = style.headingFonts[node.heading or 1],
                Text = node.text,
                TextSize = style.headingSizes[node.heading or 1],
                TextColor3 = style.textColor,
                Size = UDim2.new(1, 0, 0, h),
            })
        elseif node.type == 'Paragraph' then
            h = style.textSize
            inst = Roact.createElement("TextLabel", {
                LayoutOrder = i,
                BackgroundTransparency = 1.0,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = string.format("\t%s", node.text),
                TextSize = style.textSize,
                TextColor3 = style.textColor,
                Font = style.textFont,
                Size = UDim2.new(1, 0, 0, h),
                TextWrapped = true,
            })
        elseif node.type == 'ListItem' then
            h = style.textSize
            inst = Roact.createElement("TextLabel", {
                LayoutOrder = i,
                BackgroundTransparency = 1.0,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = ('\t'):rep(node.indent or 1) .. style.bullets[node.indent or 1] .. ' ' .. node.text,
                TextWrapped = true,
                TextSize = style.textSize,
                TextColor3 = style.textColor,
                Font = style.textFont,
                Size = UDim2.new(1, 0, 0, h),
            })
        end
        children[#children + 1] = inst
        height = height + h
    end

	return Roact.createElement("ScrollingFrame", {
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = props.Size,
        CanvasSize = UDim2.new(0, 0, 0, height),
        BorderSizePixel = 0,
    }, children)
end

return InfoPage