dp = require('../../src/twotapJSONDataProvider.js')
fixture = require('./fixtures/57da89bf7b79966e4d57d308.json').response

userDetails = {
	"email":"test@gmail.com",
	"shipping_first_name":"Bonnie",
	"shipping_last_name":"Wiseman",
	"shipping_address":"3900 Simpson Avenue",
	"shipping_city":"Millersville",
	"shipping_state":"Pennsylvania",
	"shipping_country":"United States of America",
	"shipping_zip":"17551",
	"shipping_telephone":"717-872-1812",
	"billing_first_name":"Bonnie",
	"billing_last_name":"Wiseman",
	"billing_address":"3900 Simpson Avenue",
	"billing_city":"Millersville",
	"billing_state":"Pennsylvania",
	"billing_country":"United States of America",
	"billing_zip":"17551",
	"billing_telephone":"717-872-1812",
	"card_type":"Visa",
	"card_number":"5358831008047065", 
	"card_name":"Bonnie Wiseman", 
	"expiry_date_year":"2019",         
	"expiry_date_month":"12",   
	"cvv":"232"
}

# Implement some useful shorthand utils for testing
console.log('[*] Adding testing shorthand functions')
l = console.log
j = require('circular-json').stringify
p = (item) -> l(j(item, null, 4))
k = (item) -> l(Object.keys(item))

# Test Harness
chai = require('chai')
expect = chai.expect
chaiAsPromised = require('chai-as-promised')
chai.use(chaiAsPromised)

describe.only "055.Purchase", ->

	service = undefined
	cart = undefined

	beforeEach ->
		service = new dp.JSONDataProvider()
		service.GetCart(fixture).then (result)-> cart = result
			
	describe "Purchase", ->
		it "exists", -> expect(service).to.have.property('Purchase')

		describe "throws an error if", ->			
			it 'No parameter', -> expect(service.Purchase()).to.be.rejectedWith("Missing cart parameter")
			it 'Invalid parameter', -> expect(service.Purchase({})).to.be.rejectedWith("Invalid cart parameter")
			# it 'No CartId', -> expect(service.pollCart(wishlist)).to.be.rejectedWith("No cartId provided")
		
		it "Cart has 1 site", -> expect(cart.sites).to.have.length(1)
		it "Site has 1 product", -> expect(cart.sites[0].add_to_cart).to.have.length(1)
		describe "AddToCart[0] Selections", ->
			product = undefined
			option = undefined

			beforeEach -> 
				product = cart.sites[0].add_to_cart[0]

			it "Has 2 options", -> expect(product.required_fields).to.have.length(2)

			describe "Option 1", ->
				beforeEach -> option = product.required_fields[0]

				it "Has observableValues", -> expect(option).to.have.property('observableValues')

				describe "Click on value 2", ->
					beforeEach -> service.clickOption(option.observableValues[1])

					it "is selected", -> expect(product.required_fields[0]).to.have.property('selected')
					it "has the value 'SM'", -> expect(product.required_fields[0].selected).to.have.property('text', 'SM')

			describe "Option 2", ->
				beforeEach -> option = product.required_fields[1]

				it "Has observableValues", -> expect(option).to.have.property('observableValues')

				describe "Click on value 2", ->
					beforeEach -> service.clickOption(option.observableValues[1])

					it "is selected", -> expect(product.required_fields[1]).to.have.property('selected')
					it "has the value '2'", -> expect(product.required_fields[1].selected).to.have.property('text', 2)

			describe "has", ->
				beforeEach ->
					service.clickOption(product.required_fields[0].observableValues[1])
					service.clickOption(product.required_fields[1].observableValues[1])
				it "size: 'SM'", ->
					expect(product.required_fields[0]).to.have.property('name', 'size')
					expect(product.required_fields[0].selected).to.have.property('text', 'SM')
				it "quantity: 2", ->
					expect(product.required_fields[1]).to.have.property('name', 'quantity')
					expect(product.required_fields[1].selected).to.have.property('text', 2)
				it "has product id 'fa13caea5f91f124a0088ffda58d8b4a'", -> expect(product).to.have.property('id', 'fa13caea5f91f124a0088ffda58d8b4a')
		
		describe "calls", ->
			# describe "throws an error if", ->
				# it "No cart"
				# it "Invalid cart"
				# it "Unselected options"

			describe "with valid address and billing fixtures", ->
				it "returns a PurchaseModel", -> expect(service.Purchase(cart, userDetails)).to.eventually.be.instanceOf(Twotapjs.Models.PurchaseModel)

	describe "PurchaseModel", ->
		# it "has the siteId as object key", -> expect(purchase).to.have.property('SITEID')
		# it "has an addToCart object", -> expect(purchase[SITEID]).to.have.property('addToCart')
		# it "has the productId as an object key", -> expect(purchase[SITEID].addToCart).to.have.property('PRODUCTID')
		# it "has 2 keys: size and quantity", -> expect(Object.keys(purchase[SITEID].addToCart[PRODUCTID])).to.have.length(2)
		# it "has size 'SM'", -> expect(purchase[SITEID].addToCart[PRODUCTID]).to.have.property('size', 'SM')
		# it "has quantity 2", -> expect(purchase[SITEID].addToCart[PRODUCTID]).to.have.property('quantity', 2)

