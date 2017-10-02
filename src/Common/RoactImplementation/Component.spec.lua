return function()
	local Component = require(script.Parent.Component)

	it("should be extendable", function()
		local MyComponent = Component:extend("The Senate")

		expect(MyComponent).to.be.ok()
		expect(MyComponent.new).to.be.ok()
	end)

	it("should use a given name", function()
		local MyComponent = Component:extend("FooBar")

		local name = tostring(MyComponent)

		expect(name).to.be.a("string")
		expect(name:find("FooBar")).to.be.ok()
	end)

	it("should throw on render by default", function()
		local MyComponent = Component:extend("Foo")

		local instance = MyComponent.new({})

		expect(instance).to.be.ok()

		expect(function()
			instance:render()
		end).to.throw()
	end)

	it("should pass props to the initializer", function()
		local MyComponent = Component:extend("Wazo")

		local callCount = 0
		local testProps = {}

		function MyComponent:init(props)
			expect(props).to.equal(testProps)
			callCount = callCount + 1
		end

		MyComponent.new(testProps)

		expect(callCount).to.equal(1)
	end)
end