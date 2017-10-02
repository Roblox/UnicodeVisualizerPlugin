return {
	BLACK = Color3.new(0.1, 0.1, 0.1),
	WHITE = Color3.new(0.95, 0.95, 0.95),

	GRAY1 = Color3.new(0.87, 0.87, 0.87),
	GRAY2 = Color3.new(0.7, 0.7, 0.7),
	GRAY3 = Color3.new(0.5, 0.5, 0.5),

	HIGHLIGHT1 = Color3.fromRGB(100, 153, 239),

    MARGIN = 7,
    PAD = 5,
    HALFPAD = 2,
    BYTE = 30,
    CODEPOINT = 100,
    ROW = 20,
    XOFF = 32,
    YOFF = 16,

    UTF1BYTE = Color3.fromRGB(180, 255, 180),
    UTF2BYTE = Color3.fromRGB(127, 255, 127),
    UTF3BYTE = Color3.fromRGB(255, 255, 127),
    UTF4BYTE = Color3.fromRGB(96, 160, 255),
    UTFCONT = Color3.fromRGB(255, 255, 255),
    INVALID = Color3.fromRGB(255, 0, 0),

    styles = {
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
        },
        Byte = {},
        Codepoint = {},
        Grapheme = {
            BackgroundTransparency = 0.3,
            MaxTextSize = 36,
        },
    }
}
