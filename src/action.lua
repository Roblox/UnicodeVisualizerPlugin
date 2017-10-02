return function(name, fn)
	return setmetatable({
		name = name,
	}, {
		__call = function(self, ...)
			local result = fn(...)

			result.type = name

			return result
		end
	})
end