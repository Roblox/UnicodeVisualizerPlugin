local function setText(text, confirm)
	return {
		type = 'setText',
		text = text,
		confirm = confirm or false,
	}
end

return setText
