return function()
	local Core = require(script.Parent.Core)
	local Reconciler = require(script.Parent.Reconciler)
	local PureComponent = require(script.Parent.PureComponent)

	it("should skip updates for shallow-equal props", function()
		local updateCount = 0

		local PureChild = PureComponent:extend("PureChild")

		function PureChild:willUpdate(newProps, newState)
			updateCount = updateCount + 1
		end

		function PureChild:render()
		end

		local PureContainer = PureComponent:extend("PureContainer")

		function PureContainer:init()
			self.state = {
				value = 0
			}
		end

		function PureContainer:render()
			return Core.createElement(PureChild, {
				value = self.state.value
			})
		end

		local element = Core.createElement(PureContainer)
		local instance = Reconciler.reify(element)

		expect(updateCount).to.equal(0)

		instance:setState({
			value = 1
		})

		expect(updateCount).to.equal(1)

		instance:setState({
			value = 1
		})

		expect(updateCount).to.equal(1)

		instance:setState({
			value = 2
		})

		expect(updateCount).to.equal(2)

		instance:setState({
			value = 1
		})

		expect(updateCount).to.equal(3)
	end)
end