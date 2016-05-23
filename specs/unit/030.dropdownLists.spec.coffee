l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')

describe "030. Dropdown Lists", ->
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

		it "product has 4 options", -> expect(product.required_fields).to.have.length(4)