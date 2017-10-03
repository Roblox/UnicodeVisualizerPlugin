local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)

local constants = require(Modules.constants)
local toggleEnabled = require(Modules.actions.toggleEnabled)
local toggleFullscreen = require(Modules.actions.toggleFullscreen)
local setWindowPos = require(Modules.actions.setWindowPos)
local setWindowSize = require(Modules.actions.setWindowSize)
local Input = require(Modules.components.Input)
local Data = require(Modules.components.Data)
local Info = require(Modules.components.Info)

local function MainFrame(props)
	local fullscreen = props.fullscreen
	return Roact.createElement("Frame", {
		Size = fullscreen and UDim2.new(1, 0, 1, 0) or UDim2.new(0, props.windowSize.x, 0, props.windowSize.y),
		Position = fullscreen and UDim2.new(0, 0, 0, 0) or UDim2.new(0, props.windowPos.x, 0, props.windowPos.y),
		Active = true,
		BackgroundTransparency = 1.0,
		BorderSizePixel = 0,
	}, {
		Close = Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1.0,
			Position = UDim2.new(1, -6, 0, 6),
			Size = UDim2.new(0, 16, 0, 16),
			ZIndex = 3,
			Image = "http://www.roblox.com/asset/?id=1083252600",

			[Roact.Event.MouseButton1Click] = function(rbx)
				props.close()
			end,
		}),
		Maximize = Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1.0,
			Position = UDim2.new(1, -28, 0, 6),
			Size = UDim2.new(0, 16, 0, 16),
			ZIndex = 3,
			Image = "http://www.roblox.com/asset/?id=1083254779",

			[Roact.Event.MouseButton1Click] = function(rbx)
				props.toggleFullscreen()
			end,
		}),
		Picker = Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1.0,
			Position = UDim2.new(1, -50, 0, 6),
			Size = UDim2.new(0, 16, 0, 16),
			ZIndex = 3,
			Image = "http://www.roblox.com/asset/?id=1083248618",

			[Roact.Event.MouseButton1Click] = function(rbx)
			end,
		}),
		Resize = Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1.0,
			Position = UDim2.new(1, 0, 1, 0),
			Size = UDim2.new(0, 8, 0, 8),
			ImageRectSize = Vector2.new(8, 8),
			Image = "http://www.roblox.com/asset/?id=1083257419",
			ZIndex = 3,

			[Roact.Event.InputBegan] = function(rbx, input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end
				local UIS = game:GetService("UserInputService")
				local conn1, conn2
				local start = Vector2.new(input.Position.x, input.Position.y)
				local old = rbx.Parent.AbsoluteSize

				conn1 = UIS.InputChanged:Connect(function(input2)
					if input2.UserInputType == Enum.UserInputType.MouseMovement then
						local vec = Vector2.new(input2.Position.x, input2.Position.y)
						local new = old + vec - start
						props.setWindowSize(new)
					end
				end)
				conn2 = UIS.InputEnded:Connect(function(input2)
					if input == input2 then
						conn1:Disconnect()
						conn2:Disconnect()
					end
				end)
			end,
		}),
		Container = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1.0,
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			Titlebar = not fullscreen and Roact.createElement('ImageButton', {
				LayoutOrder = -1,
				Size = UDim2.new(1, 0, 0, 32),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(120, 120, 255),
				AutoButtonColor = false,

				[Roact.Event.InputBegan] = function(rbx, input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end
					local UIS = game:GetService("UserInputService")
					local conn1, conn2
					local start = Vector2.new(input.Position.x, input.Position.y)
					local old = rbx.AbsolutePosition

					conn1 = UIS.InputChanged:Connect(function(input2)
						if input2.UserInputType == Enum.UserInputType.MouseMovement then
							local vec = Vector2.new(input2.Position.x, input2.Position.y)
							local new = old + vec - start
							props.setWindowPos(new)
						end
					end)
					conn2 = UIS.InputEnded:Connect(function(input2)
						if input == input2 then
							conn1:Disconnect()
							conn2:Disconnect()
						end
					end)
				end,
			}) or nil,
			Input = Roact.createElement(Input),
			Body = Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 1, fullscreen and -50 or -82),
				BackgroundTransparency = 1.0,
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
				}),
				Data = Roact.createElement(Data, {
					Size = props.selected and UDim2.new(.7, 0, 1, 0) or UDim2.new(1, 0, 1, 0),
				}),
				Info = Roact.createElement(Info, {
					Size = props.selected and UDim2.new(.3, 0, 1, 0) or UDim2.new(0, 0, 0, 0),
				}),
			})
		})
	})
end

MainFrame = RoactRodux.connect(function(store)
	local state = store:GetState()

	return {
		selected = state.selected,
		fullscreen = state.fullscreen,
		windowPos = state.windowPos,
		windowSize = state.windowSize,
        close = function()
            store:Dispatch(toggleEnabled())
        end,
		toggleFullscreen = function()
			store:Dispatch(toggleFullscreen())
		end,
		setWindowPos = function(pos)
			store:Dispatch(setWindowPos(pos))
		end,
		setWindowSize = function(size)
			store:Dispatch(setWindowSize(size))
		end,
	}
end)(MainFrame)

return MainFrame