local CodepointInfo = {}
CodepointInfo.__index = CodepointInfo

function CodepointInfo.new(parent, codepoint)
	local self = setmetatable({}, CodepointInfo)
	self.codepoint = codepoint
	self.frame = Instance.new("Frame")
	self.frame.Size = UDim2.new(1, 0, 1, 0)
	self.frame.BackgroundTransparency = 1.0



	self.frame.Parent = parent

	return self
end

function CodepointInfo:Destroy()
	self.frame:Destroy()
end

return CodepointInfo
