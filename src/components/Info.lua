local TweenService = game:GetService("TweenService")

local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local InfoPage = require(Modules.Plugin.Components.InfoPage)

local spinnerTween = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1)

local function Info(props)
	if props.selectionInfo then
		return Roact.createElement(InfoPage, {
			nodes = props.selectionInfo,
			Size = props.Size,
		})
	elseif props.selected then
		-- display loading spinner
		return Roact.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			Size = props.Size,
			BorderSizePixel = 0,
		}, {
			Spinner = Roact.createElement("ImageLabel", {
				Image = 'http://www.roblox.com/asset/?id=714343976',
				BackgroundTransparency = 1.0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(0, 96, 0, 96),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,

				[Roact.Ref] = function(rbx)
					if rbx then
						local tween = TweenService:Create(rbx, spinnerTween, { Rotation = 360, })
						tween:Play()
					end
				end
			})
		})
	else
		return nil
	end
end

local function mapStateToProps(state)
	return {
		selected = state.selected,
		selectionInfo = state.selectionInfo,
	}
end

Info = RoactRodux.connect(mapStateToProps)(Info)

return Info
