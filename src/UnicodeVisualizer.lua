local PAD = 5
local HALFPAD = math.floor(PAD / 2)
local BYTE = 30
local CODEPOINT = 100
local ROW = 20
local XOFF = 40
local YOFF = 16

local UTF1BYTE = Color3.fromRGB(255, 255, 255)
local UTF2BYTE = Color3.fromRGB(127, 255, 127)
local UTF3BYTE = Color3.fromRGB(255, 255, 127)
local UTF4BYTE = Color3.fromRGB(127, 255, 255)
local UTFCONT = Color3.fromRGB(230, 230, 230)
local INVALID = Color3.fromRGB(255, 0, 0)

local gui = script.UnicodeVisualizer:Clone()
local input = gui.Frame.Input
local scroll = gui.Frame.ScrollingFrame
local active = false

local toolbar = plugin:CreateToolbar("Unicode")
local button = toolbar:CreateButton("Visualizer", "View the details of any Unicode string", "rbxassetid://1062292973")

local styles = {
	LegendTop = {
		BackgroundTransparency = 1.0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
	},
	LegendLeft = {
		BackgroundTransparency = 1.0,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
	}
}

local function label(opts)
	local f = Instance.new("TextLabel")
	f.Text = opts.text or error("Missing opts.text in label(opts)")
	f.Font = Enum.Font.SourceSans
	f.TextColor3 = Color3.fromRGB(0, 0, 0)
	f.TextSize = 20
	f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	f.BackgroundTransparency = 0.15
	f.BorderColor3 = Color3.fromRGB(0, 0, 0)

	local xs = {
		[1] = 0,
		[2] = XOFF + PAD,
		[3] = XOFF + PAD + BYTE + PAD,
		[4] = XOFF + PAD + BYTE + PAD + CODEPOINT + PAD,
		[5] = scroll.AbsoluteSize.X - scroll.ScrollBarThickness,
	}

	local x = opts.x or error("Missing opts.x in label(opts)")
	local y = opts.y or error("Missing opts.y in label(opts)")
	f.Position = UDim2.new(0, xs[x], 0, 1)
	local width = xs[x + 1] - xs[x] - PAD
	local rows = opts.h or 1
	local height = rows * ROW + math.max(0, rows - 1) * PAD
	f.Size = UDim2.new(0, width, 0, height)
	f.Name = string.format("%d,%d: %s", opts.x, opts.y, opts.text)
	f.ZIndex = 3
	if opts.style then
		for k,v in pairs(styles[opts.style] or error("Style does not exist")) do
			f[k] = v
		end
	end
	if opts.override then
		for k,v in pairs(opts.override) do
			f[k] = v
		end
	end
	local row = scroll:FindFirstChild(tostring(y))
	if not row then
		row = Instance.new("Frame")
		row.Name = tostring(y)
		row.Parent = scroll
		row.Size = UDim2.new(1, 0, 0, ROW + 2)
		row.Position = UDim2.new(0, 0, 0, (ROW + PAD) * (y - 1) - 1)
		row.BackgroundTransparency = y % 2 ~= 0 and 0.75 or 1.0
		row.Parent = scroll
	end
	f.Parent = row
	return f
end

local function update()
	gui.Parent = active and game:GetService("CoreGui") or nil
	button:SetActive(active)
	if not active then return end
	scroll:ClearAllChildren()
	local str = input.Text

	scroll.CanvasSize = UDim2.new(0, 0, 0, (#str + 1) * (ROW + PAD) + YOFF)

	local legends = { "Offset", "Byte", "Codepoint", "Grapheme Cluster" }
	for i = 1, #legends do
		label{
			x = i, y = 1,
			text = legends[i],
			style = i == 1 and 'LegendLeft' or 'LegendTop',
		}
	end

	for i = 1, #str do
		label{
			x = 1, y = i + 1,
			text = string.format("%d", i),
			style = 'LegendLeft',
		}
		local byte = str:byte(i,i)
		local color
		if byte <= 0x7f then
			color = UTF1BYTE
		elseif byte <= 0xBF then
			color = UTFCONT
		elseif byte <= 0xDF then
			color = UTF2BYTE
		elseif byte <= 0xEF then
			color = UTF3BYTE
		elseif byte <= 0xF7 then
			color = UTF4BYTE
		else
			color = INVALID
		end
		label{
			x = 2, y = i + 1,
			text = string.format("%02X", byte),
			override = {
				BackgroundColor3 = color,
				TextSize = 20,
			},
		}
	end

	local mapping = {
		[0x20] = 'SP',
		[0x200d] = 'ZWJ',
	}

	local function map(str, code)
		if mapping[code] then
			return mapping[code]
		end
		return str
	end

	local function drawcode(first, last, code)
		local char = map(str:sub(first, last), code)
		local text
		if last - first > 0 then
			text = string.format("%s U+%04X", char, code)
		else
			text = char
		end
		label{
			x = 3, y = first + 1,
			h = last - first + 1,
			text = text
		}
	end

	local first = 0
	local prev = nil
	for p,c in utf8.codes(str) do
		if prev then
			drawcode(first, p - 1, prev)
		end
		first = p
		prev = c
	end
	if prev then
		drawcode(first, #str, prev)
	end

	for first, last in utf8.graphemes(str) do
		label{
			x = 4, y = first + 1,
			h = last - first + 1,
			text = string.format("%s", str:sub(first, last)),
		}
	end
end

input:GetPropertyChangedSignal("Text"):Connect(update)
gui.Frame.Close.MouseButton1Down:Connect(function()
	active = false
	update()
end)
update()

button.Click:Connect(function()
	active = not active
	update()
end)
