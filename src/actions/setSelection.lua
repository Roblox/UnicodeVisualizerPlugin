local function setSelection(what)
	return {
		type = 'setSelection',
		what = what,
	}
end

return setSelection
