local Utf8 = {}

Utf8.CodeunitClass = {
	Single = 'Single',
	Continuation = 'Continuation',
	Start2 = 'Start2',
	Start3 = 'Start3',
	Start4 = 'Start4',
	Invalid = 'Invalid',
}

local function readContinuation(str, i, value, num)
	for o = 1, num - 1 do
		local byte = str:byte(i + o)
		if byte > 0x7F and byte <= 0xBF then
			value = value * 0x80 + byte
		else
			return nil
		end
	end
	return value, num
end

local function readCodepoint(str, i)
	if i > #str then
		return nil
	end
	local byte = str:byte(i)
	if byte <= 0x7F then
		return byte, 1
	elseif byte <= 0xBF then
		-- lone continuation bytes are invalid
		return nil
	elseif byte <= 0xDF then
		return readContinuation(str, i, byte, 2)
	elseif byte <= 0xEF then
		return readContinuation(str, i, byte, 3)
	elseif byte <= 0xF7 then
		return readContinuation(str, i, byte, 4)
	else
		-- values 0xF8 through 0xFF are never valid UTF-8
		return nil
	end
end

function Utf8.validSpans(str)
	local spans = {}
	local i = 1
	local errstart
	local validstart

	while i <= #str + 1 do
		local code, bytes = readCodepoint(str, i)

		if code and not validstart then
			validstart = i
		end
		if not code and not errstart then
			errstart = i
		end
		if code and errstart then
			spans[#spans+1] = {
				text = nil,
				first = errstart,
				last = i - 1,
			}
			errstart = nil
		end
		if validstart and not code then
			spans[#spans+1] = {
				text = str:sub(validstart, i - 1),
				first = validstart,
				last = i - 1,
			}
			validstart = nil
		end

		if code then
			i = i + bytes
		else
			i = i + 1
		end
	end

	return spans
end

function Utf8.classifyCodeunit(unit)
	if unit <= 0x7F then
		return Utf8.CodeunitClass.Single
	elseif unit <= 0xBF then
		return Utf8.CodeunitClass.Continuation
	elseif unit <= 0xDF then
		return Utf8.CodeunitClass.Start2
	elseif unit <= 0xEF then
		return Utf8.CodeunitClass.Start3
	elseif unit <= 0xF7 then
		return Utf8.CodeunitClass.Start4
	end
	return Utf8.CodeunitClass.Invalid
end

function Utf8.classifyCodeunits(str)
	local units = {}
	for i = 1, #str do
		local unit = str:byte(i)
		local class = Utf8.classifyCodeunit(unit)

		units[i] = {
			value = unit,
			class = class,
			pos = i,
		}
	end
	return units
end

function Utf8.classifyCodepoints(spans)
	local codepoints = {}

	for _,span in pairs(spans) do
		if span.text then
			for p, code in utf8.codes(span.text) do
				local char = utf8.char(code)
				codepoints[#codepoints+1] = {
					value = code,
					text = char,
					first = span.first + p - 1,
					last = span.first + p + #char - 2,
				}
			end
		else
			codepoints[#codepoints+1] = {
				text = nil,
				value = nil,
				first = span.first,
				last = span.last,
			}
		end
	end

	return codepoints
end

function Utf8.classifyGraphemes(spans)
	local graphemes = {}

	for _,span in pairs(spans) do
		if span.text then
			for first, last in utf8.graphemes(span.text) do
				graphemes[#graphemes+1] = {
					text = span.text:sub(first, last),
					first = span.first + first - 1,
					last = span.first + last - 1,
				}
			end
		else
			graphemes[#graphemes+1] = {
				text = nil,
				first = span.first,
				last = span.last,
			}
		end
	end

	return graphemes
end

return Utf8
