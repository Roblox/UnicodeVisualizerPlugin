stds.roblox = {
	read_globals = {
		game = {
			other_fields = true,
		},

		-- Roblox libraries
		"utf8",

		-- Roblox globals
		"script",

		-- Extra functions
		"tick", "warn", "spawn",
		"wait", "settings",
		"typeof",

		-- Types
		"Vector2", "Vector3",
		"Color3",
		"UDim", "UDim2",
		"Rect",
		"CFrame",
		"Enum",
		"Instance",
		"TweenInfo",
		"DockWidgetPluginGuiInfo",
	}
}

stds.testez = {
	read_globals = {
		"describe",
		"it", "itFOCUS", "itSKIP",
		"FOCUS", "SKIP", "HACK_NO_XPCALL",
		"expect",
	}
}

stds.plugin = {
	read_globals = {
		"plugin",
	}
}

ignore = {
	"212", -- unused arguments
	"411", -- redefining local variable
	"421", -- shadowing local variable
	"422", -- shadowing argument
	"431", -- shadowing upvalue
	"432", -- shadowing upvalue argument
}

std = "lua51+roblox"

files["**/*.server.lua"] = {
	std = "+plugin",
}

files["**/*.spec.lua"] = {
	std = "+testez",
}
