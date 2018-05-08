local function setSelectionInfo(of, what)
	return {
        type = 'setSelectionInfo',
        of = of,
		what = what,
	}
end

return setSelectionInfo
