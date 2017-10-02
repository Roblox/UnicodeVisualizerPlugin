--[[
	Packages up the internals of Roact and exposes a public API for it.

	See the 'RoactImplementation' folder for the actual implementation of Roact,
	this file exists just to expose it from a single module.
]]

local Implementation = script.Parent.RoactImplementation

local Core = require(Implementation.Core)
local Reconciler = require(Implementation.Reconciler)
local Component = require(Implementation.Component)
local PureComponent = require(Implementation.PureComponent)
local Debug = require(Implementation.Debug)

--[[
	A utility to copy one module into another, erroring if there are
	overlapping keys.
]]
local function apply(target, source)
	for key, value in pairs(source) do
		if target[key] ~= nil then
			error(("Roact: key %q was overridden!"):format(key), 2)
		end

		-- Don't add internal values
		if not key:find("^_") then
			target[key] = value
		end
	end
end

local Roact = {}

apply(Roact, Core)
apply(Roact, Reconciler)

apply(Roact, {
	Component = Component,
	PureComponent = PureComponent,
})

-- Apply unstable modules in a special place.
apply(Roact, {
	Unstable = {
		Debug = Debug,
	}
})

return Roact