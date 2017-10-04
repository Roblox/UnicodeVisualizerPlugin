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
                TextWrapped = true,
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
                    local TextService = game:GetService("TextService")
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