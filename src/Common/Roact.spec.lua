return function()
	local Roact = require(script.Parent.Roact)

	it("should load", function()
		expect(Roact).to.be.ok()
		expect(Roact.createElement).to.be.ok()
	end)

	describe("Props", function()
		it("should be passed to primitive components", function()
			local container = Instance.new("IntValue")

			local element = Roact.createElement("StringValue", {
				Value = "foo"
			})

			Roact.reify(element, container, "TestStringValue")

			local rbx = container:FindFirstChild("TestStringValue")

			expect(rbx).to.be.ok()
			expect(rbx.Value).to.equal("foo")
		end)

		it("should be passed to functional components", function()
			local testProp = {}

			local callCount = 0

			local function TestComponent(props)
				expect(props.testProp).to.equal(testProp)
				callCount = callCount + 1
			end

			local element = Roact.createElement(TestComponent, {
				testProp = testProp
			})

			Roact.reify(element)

			-- The only guarantee is that the function will be invoked at least once
			expect(callCount > 0).to.equal(true)
		end)

		it("should be passed to stateful components", function()
			local testProp = {}

			local callCount = 0

			local TestComponent = Roact.Component:extend("TestComponent")

			function TestComponent:init(props)
				expect(props.testProp).to.equal(testProp)
				callCount = callCount + 1
			end

			function TestComponent:render()
			end

			local element = Roact.createElement(TestComponent, {
				testProp = testProp
			})

			Roact.reify(element)

			expect(callCount).to.equal(1)
		end)
	end)

	describe("State", function()
		it("should trigger a re-render of child components", function()
			local renderCount = 0
			local listener = nil

			local TestChild = Roact.Component:extend("TestChild")

			function TestChild:render()
				renderCount = renderCount + 1
				return nil
			end

			local TestParent = Roact.Component:extend("TestParent")

			function TestParent:init(props)
				self.state = {
					value = 0
				}
			end

			function TestParent:didMount()
				listener = function()
					self:setState({
						value = self.state.value + 1
					})
				end
			end

			function TestParent:render()
				return Roact.createElement(TestChild, {
					value = self.state.value
				})
			end

			local element = Roact.createElement(TestParent)
			Roact.reify(element)

			expect(renderCount >= 1).to.equal(true)
			expect(listener).to.be.a("function")

			listener()

			expect(renderCount >= 2).to.equal(true)
		end)
	end)

	describe("Context", function()
		it("should be passed to children through primitive and functional components", function()
			local testValue = {}

			local callCount = 0

			local ContextConsumer = Roact.Component:extend("ContextConsumer")

			function ContextConsumer:init(props)
				expect(self._context.testValue).to.equal(testValue)

				callCount = callCount + 1
			end

			function ContextConsumer:render()
				return
			end

			local function ContextBarrier(props)
				return Roact.createElement(ContextConsumer)
			end

			local ContextProvider = Roact.Component:extend("ContextProvider")

			function ContextProvider:init(props)
				self._context.testValue = props.testValue
			end

			function ContextProvider:render()
				return Roact.createElement("Frame", {}, {
					Child = Roact.createElement(ContextBarrier)
				})
			end

			local element = Roact.createElement(ContextProvider, {
				testValue = testValue
			})

			Roact.reify(element)

			expect(callCount).to.equal(1)
		end)
	end)

	describe("Ref", function()
		it("should call back with a Roblox object after properties and children", function()
			local callCount = 0

			local function ref(rbx)
				expect(rbx).to.be.ok()
				expect(rbx.ClassName).to.equal("StringValue")
				expect(rbx.Value).to.equal("Hey!")
				expect(rbx.Name).to.equal("RefTest")
				expect(#rbx:GetChildren()).to.equal(1)

				callCount = callCount + 1
			end

			local element = Roact.createElement("StringValue", {
				Value = "Hey!",
				[Roact.Ref] = ref,
			}, {
				TestChild = Roact.createElement("StringValue"),
			})

			Roact.reify(element, nil, "RefTest")

			expect(callCount).to.equal(1)
		end)

		it("should pass nil to refs for tearing down", function()
			local callCount = 0
			local currentRef

			local function ref(rbx)
				currentRef = rbx
				callCount = callCount + 1
			end

			local element = Roact.createElement("StringValue", {
				[Roact.Ref] = ref,
			})

			local instance = Roact.reify(element, nil, "RefTest")

			expect(callCount).to.equal(1)
			expect(currentRef).to.be.ok()
			expect(currentRef.Name).to.equal("RefTest")

			Roact.teardown(instance)

			expect(callCount).to.equal(2)
			expect(currentRef).to.equal(nil)
		end)

		it("should tear down refs when switched out of the tree", function()
			local updateMethod
			local refCount = 0
			local currentRef

			local function ref(rbx)
				currentRef = rbx
				refCount = refCount + 1
			end

			local function RefWrapper()
				return Roact.createElement("StringValue", {
					Value = "ooba ooba",
					[Roact.Ref] = ref,
				})
			end

			local Root = Roact.Component:extend("RefTestRoot")

			function Root:init()
				updateMethod = function(show)
					self:setState({
						show = show
					})
				end
			end

			function Root:render()
				if self.state.show then
					return Roact.createElement(RefWrapper)
				end
			end

			local element = Roact.createElement(Root)
			Roact.reify(element)

			expect(refCount).to.equal(0)
			expect(currentRef).to.equal(nil)

			updateMethod(true)

			expect(refCount).to.equal(1)
			expect(currentRef.Value).to.equal("ooba ooba")

			updateMethod(false)

			expect(refCount).to.equal(2)
			expect(currentRef).to.equal(nil)
		end)
	end)
end