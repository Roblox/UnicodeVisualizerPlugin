--[[
	Implements the start of an Asteroids clone using Roact and Rodux.

	This is intended to be an advanced example that uses most edge cases of both
	Roact and Rodux.
]]

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Common = script.Parent.Parent

local Roact = require(Common.Roact)
local Rodux = require(Common.Rodux)
local RoactRodux = require(Common.RoactRodux)
local Immutable = require(Common.Immutable)

local function playerReducer(state, action)
	state = state or {
		position = Vector2.new(0, 0),
		velocity = 0,
		angle = 0,
		turnImpulse = 0,
		throttleImpulse = 0,
		turnRate = math.pi / 2,
		throttleRate = 10,
	}

	if action.type == "GameStep" then
		local delta = action.delta
		local direction = Vector2.new(math.sin(state.angle), -math.cos(state.angle))

		return Immutable.JoinDictionaries(state, {
			position = state.position + (direction * state.velocity * delta),
			velocity = state.velocity + (state.throttleImpulse * state.throttleRate * delta),
			angle = state.angle + (state.turnImpulse * state.turnRate * delta),
		})
	elseif action.type == "SetPlayerRotation" then
		return Immutable.Set(state, "angle", action.value)
	elseif action.type == "SetPlayerTurnImpulse" then
		return Immutable.Set(state, "turnImpulse", action.value)
	elseif action.type == "SetPlayerThrottleImpulse" then
		return Immutable.Set(state, "throttleImpulse", action.value)
	end

	return state
end

local function timeReducer(state, action)
	state = state or 0

	if action.type == "GameStep" then
		return state + action.delta
	end

	return state
end

local function asteroidsReducer(state, action)
	return {}
end

local function reducer(state, action)
	state = state or {}

	return {
		player = playerReducer(state.player, action),
		time = timeReducer(state.time, action),
		asteroids = asteroidsReducer(state.asteroids, action),
	}
end

-- Defines the current camera declaratively
local Camera = Roact.Component:extend("Camera")

function Camera:init()
	self.cameraRef = function(rbx)
		self.cameraRbx = rbx
	end
end

function Camera:render()
	local focus = self.props.focus

	return Roact.createElement("Camera", {
		CameraType = Enum.CameraType.Scriptable,
		CFrame = CFrame.new(Vector3.new(focus.x, 20, focus.y)) * CFrame.fromEulerAnglesXYZ(-math.pi / 2, 0, 0),
		FieldOfView = 90,

		[Roact.Ref] = self.cameraRef,
	})
end

function Camera:didMount()
	Workspace.CurrentCamera = self.cameraRbx
end

-- A version of the camera that's tied to the player's position.
local PlayerCamera = RoactRodux.connect(function(store)
	local player = store:GetState().player

	return {
		focus = player.position
	}
end)(Camera)

-- Any ship in the game world.
local Ship = Roact.Component:extend("Ship")

function Ship:render()
	local position = self.props.position
	local angle = self.props.angle
	local time = self.props.time

	local color = Color3.fromHSV((time % 5) / 5, 1, 1)

	return Roact.createElement("Part", {
		Anchored = true,
		Size = Vector3.new(2, 2, 6),
		Color = color,
		CFrame = CFrame.new(Vector3.new(position.x, 0, position.y)) * CFrame.fromEulerAnglesXYZ(0, -angle, 0),
		FrontSurface = Enum.SurfaceType.Hinge,
	})
end

-- A version of the ship that's tied to the player's data.
local PlayerShip = RoactRodux.connect(function(store)
	local state = store:GetState()
	local player = state.player

	return {
		position = player.position,
		angle = player.angle,
		time = state.time,
	}
end)(Ship)

-- A static background
local GameBackground = Roact.Component:extend("GameBackground")

function GameBackground:render()
	return Roact.createElement("Part", {
		Anchored = true,
		Size = Vector3.new(512, 10, 512),
		Position = Vector3.new(0, -5, 0),
		Color = Color3.new(0.3, 0.35, 0.4),
	})
end

-- Connects to UserInputService when created, disconnects when removed.
local InputConnector = Roact.Component:extend("InputConnector")

function InputConnector:init()
	self._connections = {}
end

function InputConnector:render()
	return nil
end

function InputConnector:didMount()
	do
		local connection = RunService.RenderStepped:Connect(function(delta)
			self.props.onStepped(delta)
		end)
		table.insert(self._connections, connection)
	end

	do
		local connection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			local key = input.KeyCode

			if key == Enum.KeyCode.Left then
				self.props.onTurnImpulse(-1)
			elseif key == Enum.KeyCode.Right then
				self.props.onTurnImpulse(1)
			elseif key == Enum.KeyCode.Up then
				self.props.onThrottleImpulse(1)
			elseif key == Enum.KeyCode.Down then
				self.props.onThrottleImpulse(-1)
			end
		end)
		table.insert(self._connections, connection)
	end

	do
		local connection = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			local key = input.KeyCode

			if key == Enum.KeyCode.Left then
				self.props.onTurnImpulse(0)
			elseif key == Enum.KeyCode.Right then
				self.props.onTurnImpulse(0)
			elseif key == Enum.KeyCode.Up then
				self.props.onThrottleImpulse(0)
			elseif key == Enum.KeyCode.Down then
				self.props.onThrottleImpulse(0)
			end
		end)
		table.insert(self._connections, connection)
	end
end

function InputConnector:willUnmount()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end

	self._connections = {}
end

-- Connect InputConnector to actions dispatched on the store
InputConnector = RoactRodux.connect(function(store)
	return {
		onStepped = function(delta)
			store:Dispatch({
				type = "GameStep",
				delta = delta,
			})
		end,
		onTurnImpulse = function(value)
			store:Dispatch({
				type = "SetPlayerTurnImpulse",
				value = value,
			})
		end,
		onThrottleImpulse = function(value)
			store:Dispatch({
				type = "SetPlayerThrottleImpulse",
				value = value,
			})
		end,
	}
end)(InputConnector)

-- Package everything up.
local App = Roact.Component:extend("App")

function App:render()
	return Roact.createElement("Model", {}, {
		Player = Roact.createElement(PlayerShip),
		PlayerCamera = Roact.createElement(PlayerCamera),
		GameBackground = Roact.createElement(GameBackground),
		InputConnector = Roact.createElement(InputConnector),
	})
end

local function main()
	RunService.Stepped:Wait()

	local store = Rodux.Store.new(reducer)

	local app = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App),
	})

	Roact.reify(app, Workspace, "Roact-asteroids")
end

return main