local UCD = {}
UCD.__index = UCD

UCD.cache = {}

function UCD.new(name)
    if UCD.cache[name] then
        return UCD.cache[name]
    end
    local self = setmetatable({}, UCD)
    self.file = require(script:FindFirstChild(name) or error("No such UCD file exists: "..tostring(name)))
    self.properties = {}

    local lineno = 1
    for line in self.file:gmatch("([^\r\n]*)\n?") do
        line = line:match("^([^#]+)") or ""
        if #line > 0 then
            local specifier, property = line:match("^(.+);(.+)$")
            specifier = (specifier or ""):match("^%s*(.-)%s*$")
            property = (property or ""):match("^%s*(.-)%s*$")
            local first, last = specifier:match("^(%x+)%.%.(%x+)$")
            first = first or specifier:match("^(%x+)$")
            last = last or first
            if not first then
                error(string.format("[%s:%i] Syntax error: `%s`", name, lineno, line))
            end
            first = tonumber(first, 16)
            last = tonumber(last or first, 16)
            local data = self.properties[property] or {}
            self.properties[property] = data
            data[#data+1] = {
                first = first,
                last = last,
            }
        end
        lineno = lineno + 1
    end

    for prop,data in pairs(self.properties) do
        table.sort(data, function(a,b) return a.last < b.last end)
    end

    UCD.cache[name] = self
    return self
end

-- returns an array of properties
function UCD:Lookup(code)
    assert(type(code) == 'number')
    local props = {}
    for prop,data in pairs(self.properties) do
        local min = 1
        local max = #data
        while max > min do
            local pivot = math.floor((min + max) / 2)
            if data[pivot].last >= code then
                max = pivot
            else
                min = pivot + 1
            end
        end
        if data[min].first <= code and data[min].last >= code then
            props[#props+1] = prop
        end
    end
    return props
end

return UCD