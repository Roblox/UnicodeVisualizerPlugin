local files = {
	"Blocks",
	"EastAsianWidth",
	"PropList",
	"Scripts",
	"UnicodeData",
	"DerivedCoreProperties",
}

local limit = 200000
local buffer = 190000
local head =
	"-- Automatically generated by build.lua, do not edit\n"

for _,name in pairs(files) do
	local path = string.format("UCD/%s.txt", name)
	print("Building", path)
	local file = io.open(path, 'r')
	local contents = file:read("*a")
	local num = math.ceil(#contents / limit);
	if num == 1 then
		print("Below max size")
		local out = io.open(string.format("src/ucd/%s.lua", name), 'w')
		out:write(head.."return [[\n")
		out:write(contents)
		out:write("]]")
		out:flush()
		out:close()
	else
		print("Above max size, using "..num.." scripts")
		local out
		local length = math.huge
		local i = 0
		for line in contents:gmatch("([^\r\n]*)\n?") do
			if length + #line + 1 > buffer then
				if out then
					out:write("]]\n")
					out:flush()
					out:close()
					print("wrote file "..i)
				end
				i = i + 1
				out = io.open(string.format("src/ucd/%s%i.lua", name, i), 'w')
				local str = head..'return [[\n'
				out:write(str)
				length = #str
			end
			out:write(line .. '\n')
			length = length + #line + 1
		end
		out:write("]]\n")
		out:flush()
		out:close()
		print("wrote file "..i)
		local out = io.open(string.format("src/ucd/%s.lua", name), 'w')
		out:write(head.."return {\n")
		for j = 1, i do
			out:write(string.format("	require(script.Parent.%s%i),\n", name, j))
		end
		out:write("}\n")
		out:flush()
		print("wrote index file")
	end
end
