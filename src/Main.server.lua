-- When using HotSwap, your code sometimes runs in a non-plugin context
if not plugin then
	return
end

-- currentRoot will not be the same as source
local source = script.Parent
local currentRoot = script.Parent

script.Disabled = true

local PluginFacade = {
	_toolbars = {},
	_buttons = {},
	_watching = {},
	_beforeUnload = nil,
}

--[[
	Abstraction for plugin:CreateToolbar
]]
function PluginFacade:toolbar(name)
	if self._toolbars[name] then
		return self._toolbars[name]
	end

	local toolbar = plugin:CreateToolbar(name)

	self._toolbars[name] = toolbar

	return toolbar
end

--[[
	Abstraction for toolbar:CreateButton
]]
function PluginFacade:button(toolbar, name, tooltip, icon)
	local existingButtons = self._buttons[toolbar]

	if existingButtons then
		local existingButton = existingButtons[name]

		if existingButton then
			return existingButton
		end
	else
		existingButtons = {}
		self._buttons[toolbar] = existingButtons
	end

	local button = toolbar:CreateButton(name, tooltip, icon)

	existingButtons[name] = button

	return button
end

--[[
	Sets the method to call the next time the system tries to reload
]]
function PluginFacade:beforeUnload(callback)
	self._beforeUnload = callback
end

function PluginFacade:_load()
	local ok, result = pcall(require, currentRoot.Plugin)

	if not ok then
		warn("Plugin failed to load: " .. result)
		return
	end

	local Plugin = result

	ok, result = pcall(Plugin, PluginFacade)

	if not ok then
		warn("Plugin failed to run: " .. result)
		return
	end
end

function PluginFacade:_reload()
	if self._beforeUnload then
		self._beforeUnload()
		self._beforeUnload = nil
	end

	currentRoot = source:Clone()

	self:_load()
end

function PluginFacade:_watch(instance)
	if self._watching[instance] then
		return
	end

	-- Don't watch ourselves!
	if instance == script then
		return
	end

	local connection1 = instance.Changed:Connect(function(prop)
		print("Reloading due to", instance:GetFullName())

		self:_reload()
	end)

	local connection2 = instance.ChildAdded:Connect(function(instance)
		self:_watch(instance)
	end)

	local connections = {connection1, connection2}

	self._watching[instance] = connections

	for _, child in ipairs(instance:GetChildren()) do
		self:_watch(child)
	end
end

PluginFacade:_load()
PluginFacade:_watch(source)

local toolbar = PluginFacade:toolbar("Plugin Facade Debugger")

local button = PluginFacade:button(toolbar, "Reload", "Reload the Plugin Facade Debugger", "")

button.Click:Connect(function()
	spawn(function()
		print("Reloading manually...")
		PluginFacade:_reload()
	end)
end)
