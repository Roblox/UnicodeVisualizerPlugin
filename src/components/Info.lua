local Modules = script.Parent.Parent

local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local setText = require(Modules.actions.setText)

local constants = require(Modules.constants)
local InfoPage = require(Modules.components.InfoPage)
local UCD = require(Modules.ucd)

local function Info(props)
    local selected = props.selected
    local markup = {}
    if selected and selected.type == 'codepoint' then
        local propList = UCD.new("PropList")
        markup[1] = {
            type = 'Header',
            heading = 1,
            text = string.format("U+%04X '%s'", selected.code, utf8.char(selected.code)),
        }
        local props = propList:Lookup(selected.code)
        if #props > 0 then
            markup[2] = {
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
        end
    end
    return Roact.createElement(InfoPage, {
        nodes = markup,
        Size = props.Size,
    })
end

Info = RoactRodux.connect(function(store)
	local state = store:GetState()

	return {
        selected = state.selected,
	}
end)(Info)

return Info