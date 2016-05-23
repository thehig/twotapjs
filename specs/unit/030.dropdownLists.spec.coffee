l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')

describe.only "030. Dropdown Lists", ->
	source = undefined
	service = new dp.CallBackCatcherDataProvider()

	describe "ID 573defe0a5af06fc49ddd0b8", ->
		cart = undefined
		site = undefined
		product = undefined
		
		before (done)->
			service.Cart.getCart("573defe0a5af06fc49ddd0b8")
				.then (cart)->
					# console.log(JSON.stringify(cart))
					source = cart[0]
				.then(
					() -> done()
					(err)-> done(err)
				)

		beforeEach -> 
			cart = deepcopy(source)
			site = cart.sites[14]
			product = site.add_to_cart[0]

		it "cart-id of '573defe0a5af06fc49ddd0b8'", -> expect(cart).to.have.property("cart_id", "573defe0a5af06fc49ddd0b8")
		it "site-id 56bdc04e30bb1f62df001141", -> expect(site).to.have.property("id", "56bdc04e30bb1f62df001141")
		it "product-id 58eac9ffe7a7916f3a7bad1c9d6ab15c", -> expect(product).to.have.property("id", "58eac9ffe7a7916f3a7bad1c9d6ab15c")

		describe "Product", ->
			beforeEach -> Twotapjs.Utilities.processRequiredFields(product)

			it "has 4 required fields", -> expect(product.required_fields).to.have.length(4)
			it "has a selectOneModels property", -> expect(product).to.have.property('bindings')
			it "has 4 bindings", -> expect(product.bindings).to.have.length(4)

			describe "selectOneModel [0]", ->
				selectOneModel = undefined
				beforeEach -> selectOneModel = product.bindings[0]
				it "name 'option 1'", -> expect(selectOneModel).to.have.property('name', 'option 1')
				it "has 2 values", -> expect(selectOneModel.values).to.have.length(2)
				it "value [0] text 'Style: Guys Tee'", -> expect(selectOneModel.values[0]).to.have.property('text', 'Style: Guys Tee')
				it "value [1] text 'Style: Girls Tee'", -> expect(selectOneModel.values[1]).to.have.property('text', 'Style: Girls Tee')

			describe "selectOneModel [1]", ->
				selectOneModel = undefined
				beforeEach -> selectOneModel = product.bindings[1]
				it "name 'option 2'", -> expect(selectOneModel).to.have.property('name', 'option 2')
				
				describe "values", ->
					it "has 10 UNIQUE values", -> expect(selectOneModel.values).to.have.length(10)
					it "value [0] text 'Color: White'", -> expect(selectOneModel.values[0]).to.have.property('text', 'Color: White')
					it "value [1] text 'Color: Heather Gray'", -> expect(selectOneModel.values[1]).to.have.property('text', 'Color: Heather Gray')
					it "value [2] text 'Color: Light Blue'", -> expect(selectOneModel.values[2]).to.have.property('text', 'Color: Light Blue')
					it "value [3] text 'Color: Charcoal'", -> expect(selectOneModel.values[3]).to.have.property('text', 'Color: Charcoal')
					it "value [4] text 'Color: Sand'", -> expect(selectOneModel.values[4]).to.have.property('text', 'Color: Sand')
					it "value [5] text 'Color: Snow'", -> expect(selectOneModel.values[5]).to.have.property('text', 'Color: Snow')
					it "value [6] text 'Color: Sky Blue'", -> expect(selectOneModel.values[6]).to.have.property('text', 'Color: Sky Blue')
					it "value [7] text 'Color: Gray Granite'", -> expect(selectOneModel.values[7]).to.have.property('text', 'Color: Gray Granite')
					it "value [8] text 'Color: Soft Pink'", -> expect(selectOneModel.values[8]).to.have.property('text', 'Color: Soft Pink')
					it "value [9] text 'Color: Light Lemon'", -> expect(selectOneModel.values[9]).to.have.property('text', 'Color: Light Lemon')


			describe "selectOneModel [2]", ->
				selectOneModel = undefined
				beforeEach -> selectOneModel = product.bindings[2]
				it "name 'option 3'", -> expect(selectOneModel).to.have.property('name', 'option 3')
				describe "values", ->
					it "has 6 UNIQUE values", -> expect(selectOneModel.values).to.have.length(6)
					it "value [0] text 'Size: Small'", -> expect(selectOneModel.values[0]).to.have.property('text', 'Size: Small')
					it "value [1] text 'Size: Medium'", -> expect(selectOneModel.values[1]).to.have.property('text', 'Size: Medium')
					it "value [2] text 'Size: Large'", -> expect(selectOneModel.values[2]).to.have.property('text', 'Size: Large')
					it "value [3] text 'Size: X-Large'", -> expect(selectOneModel.values[3]).to.have.property('text', 'Size: X-Large')
					it "value [4] text 'Size: 2X-Large'", -> expect(selectOneModel.values[4]).to.have.property('text', 'Size: 2X-Large')
					it "value [5] text 'Size: 3X-Large'", -> expect(selectOneModel.values[5]).to.have.property('text', 'Size: 3X-Large')
					
			describe "selectOneModel [3]", ->
				selectOneModel = undefined
				beforeEach -> selectOneModel = product.bindings[3]
				it "name 'quantity'", -> expect(selectOneModel).to.have.property('name', 'quantity')