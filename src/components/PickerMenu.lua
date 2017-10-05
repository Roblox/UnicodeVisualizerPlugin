local Modules = script.Parent.Parent

local Common = Modules.Common

local Roact = require(Common.Roact)
local RoactRodux = require(Common.RoactRodux)
local setText = require(Modules.actions.setText)
local constants = require(Modules.constants)

local PickerMenu = Roact.Component:extend("PickerMenu")

function Header(props)
    return Roact.createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        ZIndex = 5,
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
        ZIndex = 5,
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
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1.0,
        Position = UDim2.new(1, -50, 0, 6),
        Size = UDim2.new(0, 16, 0, 16),
        ZIndex = 3,
        Image = "http://www.roblox.com/asset/?id=1083248618",

        [Roact.Event.MouseButton1Click] = function(rbx)
            self:setState({
                open = not self.state.open
            })
        end,
    }, {
        Menu = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 1, 0),
            Visible = self.state.open,
            Size = UDim2.new(0, 150, 0, #children * 21 - 1),
            BackgroundColor3 = borderColor,
            BorderColor3 = borderColor,
            ZIndex = 4,
            ClipsDescendants = true,
        }, children),
    })
end

function PickerMenu:init()
    self.state = {
        open = false,
    }
end

PickerMenu = RoactRodux.connect(function(store)
	local state = store:GetState()

	return {
        recentlyUsed = state.recentlyUsed,
        setText = function(text)
            store:Dispatch(setText(text))
        end,
	}
end)(PickerMenu)

return PickerMenu
