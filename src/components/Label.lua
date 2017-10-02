local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local constants = require(Modules.constants)

local function Label(props)
    local style = constants.styles[props.style] or error("Style does not exist: "..tostring(props.style))

    local sizes = {
        constants.XOFF,
        constants.BYTE,
        constants.CODEPOINT,
    }

    local x = constants.MARGIN
    local xs = {}
    for i = 1, #sizes do
        xs[i] = UDim.new(0, x)
        x = x + sizes[i] + constants.PAD
        sizes[i] = UDim.new(0, sizes[i])
    end
    xs[#xs+1] = UDim.new(0, x)
    sizes[#sizes+1] = UDim.new(1, -xs[#xs].Offset - constants.MARGIN)

	return Roact.createElement("TextLabel", {
        Text = props.text,
        Font = style.Font or Enum.Font.SourceSans,
        TextColor3 = style.TextColor3 or Color3.fromRGB(0, 0, 0),
        TextScaled = true,
        TextXAlignment = style.TextXAlignment or Enum.TextXAlignment.Center,
        TextYAlignment = style.TextYAlignment or Enum.TextYAlignment.Center,
        BackgroundColor3 = props.BackgroundColor3 or style.BackgroundColor3 or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = style.BackgroundTransparency or 0.15,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = props.ZIndex,

        Position = props.Position or UDim2.new(
            xs[props.x],
            UDim.new(0, props.y and constants.YOFF + (props.y - 2) * constants.ROW + (props.y - 1) * constants.PAD + constants.MARGIN or constants.HALFPAD)
        ),
        Size = props.Size or UDim2.new(
            sizes[props.x],
            UDim.new(0, constants.ROW * (props.h or 1) + math.max(0, constants.PAD * ((props.h or 1) - 1)))
        ),
    }, {
        UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
            MinTextSize = style.MinTextSize or 1,
            MaxTextSize = style.MaxTextSize or style.TextSize or 20,
        })
    })
end

return Label