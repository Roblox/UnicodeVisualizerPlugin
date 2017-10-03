local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local constants = require(Modules.constants)
local Label = require(Modules.components.Label)

local function Row(props)
    local byte = props.byte
    local color
    if byte <= 0x7f then
        color = constants.UTF1BYTE
    elseif byte <= 0xBF then
        color = constants.UTFCONT
    elseif byte <= 0xDF then
        color = constants.UTF2BYTE
    elseif byte <= 0xEF then
        color = constants.UTF3BYTE
    elseif byte <= 0xF7 then
        color = constants.UTF4BYTE
    else
        color = constants.INVALID
    end

	return Roact.createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(127, 127, 127),
        BackgroundTransparency = props.y % 2 == 0 and 0.75 or 1.0,
        
        Position = UDim2.new(0, 0, 0, constants.YOFF + (props.y - 2) * constants.ROW + (props.y - 1) * constants.PAD - constants.HALFPAD + constants.MARGIN),
        Size = UDim2.new(1, 0, 0, constants.ROW + constants.HALFPAD*2),
    }, {
        Offset = Roact.createElement(Label, {
            x = 1,
            style = 'LegendLeft',
            text = string.format("%d", props.offset),
        }),
        Byte = Roact.createElement(Label, {
            x = 2,
            style = 'Byte',
            text = string.format("%02X", props.byte),
            BackgroundColor3 = color,
        })
    })
end

return Row