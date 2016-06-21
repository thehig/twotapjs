l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect

describe "030. Dropdown Lists", ->
	service = new dp.CallBackCatcherDataProvider()

	# Set up a fake server to respond on the given URL with the given object
	#  Note: Only calls to the provided URL will succeed. Everything else will 404
	fakeServer = undefined
	before -> 
		fakeServer = require('./fixtures/fixture_sinon_wrapper')("http://callbackcatcher.meteorapp.com/search/body.cart_id=573defe0a5af06fc49ddd0b8", require('./fixtures/573defe0a5af06fc49ddd0b8.json'), 'once')
	after ->
		# Restore the HTTP service afterward so other tests dont break
		fakeServer.restore()

	describe "ID 573defe0a5af06fc49ddd0b8", ->
		cart = undefined
		site = undefined
		product = undefined
		
		beforeEach (done)->
			service.GetCart("573defe0a5af06fc49ddd0b8")
				.then (source)->
					# console.log(JSON.stringify(cart))
					cart = source
					site = cart.sites[14]
					product = site.add_to_cart[0]
				.then(
					() -> done()
					(err)-> done(err)
				)

		it "cart-id of '573defe0a5af06fc49ddd0b8'", -> expect(cart).to.have.property("cart_id", "573defe0a5af06fc49ddd0b8")
		it "site-id 56bdc04e30bb1f62df001141", -> expect(site).to.have.property("id", "56bdc04e30bb1f62df001141")
		it "product-id 58eac9ffe7a7916f3a7bad1c9d6ab15c", -> expect(product).to.have.property("id", "58eac9ffe7a7916f3a7bad1c9d6ab15c")

		describe "Product [0]", ->
			selectOneModel = undefined
			afterEach -> selectOneModel = undefined

			it "has 4 required fields", -> expect(product.required_fields).to.have.length(4)

			describe "Option 1", ->
				beforeEach -> selectOneModel = product.required_fields[0]
				it "name 'option 1'", -> expect(selectOneModel).to.have.property('name', 'option 1')
				it "has length 2", -> expect(selectOneModel.values).to.have.length(2)

				describe "values text Style:", ->
					it "[0] 'Guys Tee'", -> expect(selectOneModel.values[0]).to.have.property('text', 'Style: Guys Tee')
					it "[1] 'Girls Tee'", -> expect(selectOneModel.values[1]).to.have.property('text', 'Style: Girls Tee')

			describe "Option 2", ->
				beforeEach -> selectOneModel = product.required_fields[1]
				it "name 'option 2'", -> expect(selectOneModel).to.have.property('name', 'option 2')
				it "has length 10", -> expect(selectOneModel.values).to.have.length(10)
				
				describe "values text Color:", ->

					describe "[0] 'White'", ->
						item = undefined
						beforeEach -> item = selectOneModel.values[0]
						it "text 'White'", -> expect(item).to.have.property('text', 'Color: White')
						it "parentOption 'Style: Guys Tee'", -> expect(item.parentOption).to.have.property('text', 'Style: Guys Tee')

					it "[1] 'Heather Gray'", -> expect(selectOneModel.values[1]).to.have.property('text', 'Color: Heather Gray')
					it "[2] 'Light Blue'", -> expect(selectOneModel.values[2]).to.have.property('text', 'Color: Light Blue')
					it "[3] 'Charcoal'", -> expect(selectOneModel.values[3]).to.have.property('text', 'Color: Charcoal')
					it "[4] 'Sand'", -> expect(selectOneModel.values[4]).to.have.property('text', 'Color: Sand')


					describe "[5] 'Snow'", ->
						item = undefined
						beforeEach -> item = selectOneModel.values[5]
						it "text 'Snow'", -> expect(item).to.have.property('text', 'Color: Snow')
						it "parentOption 'Style: Girls Tee'", -> expect(item.parentOption).to.have.property('text', 'Style: Girls Tee')
						it "parentOptions parentModel name 'option 1'", -> expect(item.parentOption.parentModel).to.have.property('name', 'option 1')

					it "[6] 'Sky Blue'", -> expect(selectOneModel.values[6]).to.have.property('text', 'Color: Sky Blue')
					it "[7] 'Gray Granite'", -> expect(selectOneModel.values[7]).to.have.property('text', 'Color: Gray Granite')
					it "[8] 'Soft Pink'", -> expect(selectOneModel.values[8]).to.have.property('text', 'Color: Soft Pink')
					it "[9] 'Light Lemon'", -> expect(selectOneModel.values[9]).to.have.property('text', 'Color: Light Lemon')


			describe "Option 3", ->
				beforeEach -> selectOneModel = product.required_fields[2]
				it "name 'option 3'", -> expect(selectOneModel).to.have.property('name', 'option 3')
				it "has length 50", -> expect(selectOneModel.values).to.have.length(50)

				describe "values text Size:", ->
					describe "[0] 'Small'", ->
						item = undefined
						beforeEach -> item = selectOneModel.values[0]
						it "text 'Small'", -> expect(item).to.have.property('text', 'Size: Small')
						it "parentOption 'Color: White'", -> expect(item.parentOption).to.have.property('text', 'Color: White')

					it "[1] 'Medium'", -> expect(selectOneModel.values[1]).to.have.property('text', 'Size: Medium')
					it "[2] 'Large'", -> expect(selectOneModel.values[2]).to.have.property('text', 'Size: Large')
					it "[3] 'X-Large'", -> expect(selectOneModel.values[3]).to.have.property('text', 'Size: X-Large')
					it "[4] '2X-Large'", -> expect(selectOneModel.values[4]).to.have.property('text', 'Size: 2X-Large')
					it "[5] '3X-Large'", -> expect(selectOneModel.values[5]).to.have.property('text', 'Size: 3X-Large')


					describe "[6] 'Small'", ->
						item = undefined
						beforeEach -> item = selectOneModel.values[6]
						it "text 'Small'", -> expect(item).to.have.property('text', 'Size: Small')
						it "parentOption 'Color: Heather Gray'", -> expect(item.parentOption).to.have.property('text', 'Color: Heather Gray')

					
			describe "Quantity", ->
				beforeEach -> selectOneModel = product.required_fields[3]
				it "name 'quantity'", -> expect(selectOneModel).to.have.property('name', 'quantity')