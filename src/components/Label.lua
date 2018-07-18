local Modules = script.Parent.Parent

local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local constants = require(Modules.constants)
local select = require(Modules.actions.select)
local setTooltip = require(Modules.actions.setTooltip)

local Label = Roact.Component:extend("Label")

function Label:render()
	local props = self.props
	local style = constants.styles[props.style] or error("Style does not exist: "..tostring(props.style))

	local selected =
		props.selectable and
		props.selected and
		props.selectable.type == props.selected.type and
		props.selectable.id == props.selected.id
	local selectedColor = Color3.fromRGB(200, 200, 200)

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

	local pos = constants.HALFPAD
	local y = props.y
	if y then
		pos = constants.YOFF + (y - 2) * constants.ROW + (y - 1) * constants.PAD + constants.MARGIN
	end

	local class = props.selectable and "TextButton" or "TextLabel"
	return Roact.createElement(class, {
		Text = props.text,
		Font = style.Font or Enum.Font.SourceSans,
		TextColor3 = style.TextColor3 or Color3.fromRGB(0, 0, 0),
		TextScaled = true,
		TextXAlignment = style.TextXAlignment or Enum.TextXAlignment.Center,
		TextYAlignment = style.TextYAlignment or Enum.TextYAlignment.Center,
		BackgroundColor3 =
			selected and selectedColor or
			props.BackgroundColor3 or
			style.BackgroundColor3 or
			Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = style.BackgroundTransparency or 0.15,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = (selected or self.state.hover) and 3 or 1,
		ZIndex = props.ZIndex,
		AutoButtonColor = props.selectable and false or not props.selectable and nil,

		Position = props.Position or UDim2.new(
			xs[props.x],
			UDim.new(0, pos)
		),
		Size = props.Size or UDim2.new(
			sizes[props.x],
			UDim.new(0, constants.ROW * (props.h or 1) + math.max(0, constants.PAD * ((props.h or 1) - 1)))
		),

		[Roact.Event.MouseEnter] = (props.selectable or props.tooltip) and function(rbx)
			if props.selectable then
				self:setState({
					hover = true,
				})
			end
			props.setTooltip(props.tooltip)
		end or nil,
		[Roact.Event.MouseLeave] = (props.selectable or props.tooltip) and function(rbx)
			if props.selectable then
				self:setState({
					hover = false,
				})
			end
			props.setTooltip(nil)
		end or nil,
		[Roact.Event.MouseButton1Click] = props.selectable and function(rbx)
			props.select(props.selectable)
		end or nil,
	}, {
		UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MinTextSize = style.MinTextSize or 1,
			MaxTextSize = style.MaxTextSize or style.TextSize or 20,
		})
	})
end

function Label:init()
	self.state = {
		hover = false,
	}
end

Label = RoactRodux.connect(function(store)
	local state = store:getState()

	return {
		selected = state.selected,
		select = function(selectable)
			store:dispatch(select(selectable))
		end,
		setTooltip = function(tooltip)
			store:dispatch(setTooltip(tooltip))
		end,
	}
end)(Label)

return Label
