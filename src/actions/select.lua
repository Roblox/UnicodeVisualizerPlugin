local RunService = game:GetService("RunService")

local Modules = script.Parent.Parent.Parent
local Data = require(Modules.Plugin.Data)
local setSelection = require(Modules.Plugin.Actions.setSelection)
local setSelectionInfo = require(Modules.Plugin.Actions.setSelectionInfo)

local function select(selected)
	return function(store)
		store:dispatch(setSelection(selected))
		spawn(function()
			local start = -math.huge
			local cooldown = 1/90
			local function heartbeat()
				local now = tick()
				if now - start > cooldown then
					RunService.Heartbeat:Wait()
					start = tick()
				end
			end

			local propsTable = Data.new("PropList", heartbeat)
			local scriptTable = Data.new("Scripts", heartbeat)
			local blocksTable = Data.new("Blocks", heartbeat)
			local eawTable = Data.new("EastAsianWidth", heartbeat)
			local unicodeTable = Data.new("UnicodeData", heartbeat)

			local props = propsTable:Lookup(selected.code, heartbeat)
			local scripts = scriptTable:Lookup(selected.code, heartbeat)
			local blocks = blocksTable:Lookup(selected.code, heartbeat)
			local eaws = eawTable:Lookup(selected.code, heartbeat)
			local _, unicodeData = unicodeTable:Lookup(selected.code, heartbeat)

			local eawMap = {
				F = 'Fullwidth',
				H = 'Halfwidth',
				W = 'Wide',
				Na = 'Narrow',
				A = 'Ambiguous',
				N = 'Neutral',
			}
			local genClasses = {
				Ll = "Letter, Lowercase",
				Lu = "Letter, Uppercase",
				Lt = "Letter, Titlecase",
				Lm = "Letter, Modifier",
				Lo = "Letter, Other",
				Mn = "Mark, Nonspacing",
				Mc = "Mark, Spacing Combining",
				Me = "Mark, Enclosing",
				Nd = "Number, Decimal Digit",
				Nl = "Number, Letter",
				No = "Number, Other",
				Pc = "Punctuation, Connector",
				Pd = "Punctuation, Dash",
				Ps = "Punctuation, Open",
				Pe = "Punctuation, Close",
				Pi = "Punctuation, Initial quote (may behave like Ps or Pe depending on usage)",
				Pf = "Punctuation, Final quote (may behave like Ps or Pe depending on usage)",
				Po = "Punctuation, Other",
				Sm = "Symbol, Math",
				Sc = "Symbol, Currency",
				Sk = "Symbol, Modifier",
				So = "Symbol, Other",
				Zs = "Separator, Space",
				Zl = "Separator, Line",
				Zp = "Separator, Paragraph",
				Cc = "Other, Control",
				Cf = "Other, Format",
				Cs = "Other, Surrogate",
				Co = "Other, Private Use",
				Cn = "Other, Not Assigned (no characters in the file have this property)",
			}

			unicodeData = unicodeData[1] or {}
			local name = unicodeData[1]
			local unicodeProps = {
				["General Category"] = unicodeData[2] and string.format("%s (%s)", genClasses[unicodeData[2]], unicodeData[2]),
				["Combining Class"] = unicodeData[3],
				["BiDi class"] = unicodeData[4],
				["Decomposition Class"] = unicodeData[5],
			}
			local comment = unicodeData[11]
			local char = utf8.char(selected.code)

			local markup = {}
			markup[1] = {
				type = 'Header',
				heading = 1,
				text = string.format("U+%04X '%s'%s", selected.code, utf8.char(selected.code), name and ' '..tostring(name)),
			}
			if comment and comment ~= '' then
				markup[#markup+1] = {
					type = 'Paragraph',
					text = tostring(comment),
				}
			end

			if #props > 0 or #scripts > 0 or #blocks > 0 or #eaws > 0 or #unicodeProps > 0 then
				markup[#markup+1] = {
					type = 'Header',
					heading = 2,
					text = string.format("Properties"),
				}
				for i = 1, #props do
					markup[#markup+1] = {
						type = 'ListItem',
						indent = 1,
						text = props[i],
					}
				end
				for i = 1, #scripts do
					markup[#markup+1] = {
						type = 'ListItem',
						indent = 1,
						text = string.format("Script: %s", scripts[i]),
					}
				end
				for i = 1, #blocks do
					markup[#markup+1] = {
						type = 'ListItem',
						indent = 1,
						text = string.format("Block: %s", blocks[i])
					}
				end
				for i = 1, #eaws do
					markup[#markup+1] = {
						type = 'ListItem',
						indent = 1,
						text = string.format("East Asian Width: %s (%s)", eawMap[eaws[i]], eaws[i]),
					}
				end
				for k,v in pairs(unicodeProps) do
					if v ~= "" then
						markup[#markup+1] = {
							type = 'ListItem',
							indent = 1,
							text = string.format("%s: %s", k, v),
						}
					end
				end
			end
			markup[#markup+1] = {
				type = 'Header',
				heading = 3,
				text = 'UTF-8',
			}
			local charData = {}
			for _, byte in pairs{char:byte(1, -1)} do
				charData[#charData + 1] = string.format("%02X", byte)
			end
			markup[#markup+1] = {
				type = 'Table',
				rows = {
					charData,
				}
			}
			local utf16
			local code = selected.code
			if code <= 0xD7FF or code >= 0xE000 and code <= 0xFFFF then
				utf16 = { string.format("%04X", code) }
			elseif code > 0xFFFF then
				local low = code % 0x400
				local high = math.floor(code / 0x400)
				utf16 = {
					string.format("%04X", low + 0xD800),
					string.format("%04X", high + 0xDC00),
				}
			else
				utf16 = { "Invalid codepoint" }
			end
			markup[#markup+1] = {
				type = 'Header',
				heading = 3,
				text = 'UTF-16',
			}
			markup[#markup+1] = {
				type = 'Table',
				rows = {
					utf16,
				}
			}

			store:dispatch(setSelectionInfo(selected, markup))
		end)
	end
end

return select
