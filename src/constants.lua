return {
    MARGIN = 7,
    PAD = 5,
    HALFPAD = 2,
    BYTE = 30,
    CODEPOINT = 100,
    ROW = 22,
    XOFF = 32,
    YOFF = 16,
    DEFAULT_WINDOW_SIZE = Vector2.new(400, 300),
    MIN_WINDOW_SIZE = Vector2.new(400, 200),

    UTF1BYTE = Color3.fromRGB(180, 255, 180),
    UTF2BYTE = Color3.fromRGB(127, 255, 127),
    UTF3BYTE = Color3.fromRGB(255, 255, 127),
    UTF4BYTE = Color3.fromRGB(96, 160, 255),
    UTFCONT = Color3.fromRGB(255, 255, 255),
    INVALID = Color3.fromRGB(255, 0, 0),

    InfoBox = {
        headingSizes = {
            36,
            24,
            22,
            20,
            20,
        },
        headingFonts = {
            Enum.Font.SourceSansBold,
            Enum.Font.SourceSansBold,
            Enum.Font.SourceSansBold,
            Enum.Font.SourceSans,
            Enum.Font.SourceSansItalic,
        },
        bullets = {
            '•',
            '◦',
            '‣',
        },
        
        textColor = Color3.fromRGB(255, 255, 255),
        textSize = 20,
        textFont = Enum.Font.SourceSans,
    },

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
        Byte = {
            Font = Enum.Font.Code,
        },
        Codepoint = {
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
        },
        Grapheme = {
            BackgroundTransparency = 0.3,
            MaxTextSize = 36,
        },
    }
}
