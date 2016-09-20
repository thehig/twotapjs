dp = require('../../src/twotapJSONDataProvider.js')
fixture = require('./fixtures/57da89bf7b79966e4d57d308.json').response
deepcopy = require('deepcopy')

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

confirmConfig = { 
	"method": "http", 
	"http_confirm_url": "http://dev.54.93.185.230.xip.io/twotap/cart/purchaseCallback/",
	"http_finished_url": "http://dev.54.93.185.230.xip.io/twotap/cart/purchaseCallback/"
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
			describe "throws an error if", ->
				# it "No cart"
				# it "Invalid cart"
				# it "Unselected options"
				testCart = undefined
				testUser = undefined
				testConfig = undefined
				beforeEach -> 
					testCart = deepcopy(cart)
					testUser = deepcopy(userDetails)
					testConfig = deepcopy(confirmConfig)


				expectError = (item, i) ->
					it item.description, ->
						item.prepareTest()
						expect(service.Purchase(testCart, testUser, testConfig)).to.be.rejectedWith(item.rejectsWith)


				expectError(item, i) for item, i in [
					{"description": "cart is undefined", "rejectsWith" : "Missing cart parameter", "prepareTest": ()-> testCart = undefined}
					{"description": "cart is invalid", "rejectsWith" : "Invalid cart parameter", "prepareTest": ()-> testCart = {}}
					{"description": "userDetails is undefined", "rejectsWith" : "Missing User Details parameter", "prepareTest": ()-> testUser = undefined}
					{"description": "confirmConfig is undefined", "rejectsWith" : "Missing Confirm Config parameter", "prepareTest": ()-> testConfig = undefined}
					{"description": "confirmConfig.method is undefined", "rejectsWith" : "Missing Confirm Config parameter: method", "prepareTest": ()-> testConfig.method = undefined}
					{"description": "confirmConfig.http_confirm_url is undefined", "rejectsWith" : "Missing Confirm Config parameter: http_confirm_url", "prepareTest": ()-> testConfig.http_confirm_url = undefined}
					{"description": "confirmConfig.http_finished_url is undefined", "rejectsWith" : "Missing Confirm Config parameter: http_finished_url", "prepareTest": ()-> testConfig.http_finished_url = undefined}
				]

				describe "userDetails does not contain", ->

					expectError(item, i) for item, i in [
						{"description": "email", "rejectsWith" : "Missing User Details parameter: email", "prepareTest": ()-> testUser.email = undefined}
						{"description": "shipping_first_name", "rejectsWith" : "Missing User Details parameter: shipping_first_name", "prepareTest": ()-> testUser.shipping_first_name = undefined}
						{"description": "shipping_last_name", "rejectsWith" : "Missing User Details parameter: shipping_last_name", "prepareTest": ()-> testUser.shipping_last_name = undefined}
						{"description": "shipping_address", "rejectsWith" : "Missing User Details parameter: shipping_address", "prepareTest": ()-> testUser.shipping_address = undefined}
						{"description": "shipping_city", "rejectsWith" : "Missing User Details parameter: shipping_city", "prepareTest": ()-> testUser.shipping_city = undefined}
						{"description": "shipping_state", "rejectsWith" : "Missing User Details parameter: shipping_state", "prepareTest": ()-> testUser.shipping_state = undefined}
						{"description": "shipping_country", "rejectsWith" : "Missing User Details parameter: shipping_country", "prepareTest": ()-> testUser.shipping_country = undefined}
						{"description": "shipping_zip", "rejectsWith" : "Missing User Details parameter: shipping_zip", "prepareTest": ()-> testUser.shipping_zip = undefined}
						{"description": "shipping_telephone", "rejectsWith" : "Missing User Details parameter: shipping_telephone", "prepareTest": ()-> testUser.shipping_telephone = ""}
						{"description": "billing_first_name", "rejectsWith" : "Missing User Details parameter: billing_first_name", "prepareTest": ()-> testUser.billing_first_name = undefined}
						{"description": "billing_last_name", "rejectsWith" : "Missing User Details parameter: billing_last_name", "prepareTest": ()-> testUser.billing_last_name = undefined}
						{"description": "billing_address", "rejectsWith" : "Missing User Details parameter: billing_address", "prepareTest": ()-> testUser.billing_address = undefined}
						{"description": "billing_city", "rejectsWith" : "Missing User Details parameter: billing_city", "prepareTest": ()-> testUser.billing_city = undefined}
						{"description": "billing_state", "rejectsWith" : "Missing User Details parameter: billing_state", "prepareTest": ()-> testUser.billing_state = undefined}
						{"description": "billing_country", "rejectsWith" : "Missing User Details parameter: billing_country", "prepareTest": ()-> testUser.billing_country = ""}
						{"description": "billing_zip", "rejectsWith" : "Missing User Details parameter: billing_zip", "prepareTest": ()-> testUser.billing_zip = undefined}
						{"description": "billing_telephone", "rejectsWith" : "Missing User Details parameter: billing_telephone", "prepareTest": ()-> testUser.billing_telephone = ""}
						{"description": "card_type", "rejectsWith" : "Missing User Details parameter: card_type", "prepareTest": ()-> testUser.card_type = undefined}
						{"description": "card_number", "rejectsWith" : "Missing User Details parameter: card_number", "prepareTest": ()-> testUser.card_number = undefined}
						{"description": "card_name", "rejectsWith" : "Missing User Details parameter: card_name", "prepareTest": ()-> testUser.card_name = undefined}
						{"description": "expiry_date_year", "rejectsWith" : "Missing User Details parameter: expiry_date_year", "prepareTest": ()-> testUser.expiry_date_year = undefined}
						{"description": "expiry_date_month", "rejectsWith" : "Missing User Details parameter: expiry_date_month", "prepareTest": ()-> testUser.expiry_date_month = undefined}
						{"description": "cvv", "rejectsWith" : "Missing User Details parameter: cvv", "prepareTest": ()-> testUser.cvv = undefined}
					]


			describe "with valid address and billing fixtures", ->
				it "returns an object", -> 
					service.clickOption(cart.sites[0].add_to_cart[0].required_fields[0].observableValues[1])
					service.clickOption(cart.sites[0].add_to_cart[0].required_fields[1].observableValues[1])
					expect(service.Purchase(cart, userDetails, confirmConfig)).to.eventually.be.an('object')

	describe "Purchase Body", ->
		purchaseBody = undefined
		CARTID = "57d68738178b18cb0b3fe50a"
		SITEID = "52d3d515ce04fa310b00000c"
		PRODUCTID = "fa13caea5f91f124a0088ffda58d8b4a"

		beforeEach -> 
			service.clickOption(cart.sites[0].add_to_cart[0].required_fields[0].observableValues[1])
			service.clickOption(cart.sites[0].add_to_cart[0].required_fields[1].observableValues[1])
			service.Purchase(cart, userDetails, confirmConfig).then((pb)-> purchaseBody = pb)

		it "has the cart_id", -> expect(purchaseBody).to.have.property('cart_id', CARTID)
		it "has a products property", -> expect(purchaseBody).to.have.property('products')
		it "length 1", -> expect(purchaseBody.products).to.have.length(1)
		it "has test_mode 'fake_confirm'", -> expect(purchaseBody).to.have.property('test_mode', 'fake_confirm')


		describe "Purchase Selections", ->
			it "has a fields_input object", -> expect(purchaseBody).to.have.property('fields_input')
			it "has the siteId as object key", -> expect(purchaseBody.fields_input).to.have.property(SITEID)
			it "has an addToCheckout object", -> expect(purchaseBody.fields_input[SITEID]).to.have.property('addToCheckout')
			it "has the productId as an object key", -> expect(purchaseBody.fields_input[SITEID].addToCheckout).to.have.property(PRODUCTID)
			it "has 2 keys", -> expect(Object.keys(purchaseBody.fields_input[SITEID].addToCheckout[PRODUCTID])).to.have.length(2)
			it "has size 'SM'", -> expect(purchaseBody.fields_input[SITEID].addToCheckout[PRODUCTID]).to.have.property('size', 'SM')
			it "has quantity 2", -> expect(purchaseBody.fields_input[SITEID].addToCheckout[PRODUCTID]).to.have.property('quantity', 2)

		describe "User Options", ->
			hasProperty = (item, i) -> 
				it "has " + item.name + " '" + item.value + "'", -> expect(purchaseBody.fields_input[SITEID].noauthCheckout).to.have.property(item.name, item.value)

			hasProperty(item, i) for item, i in [
				{"name": "email", "value": "test@gmail.com"}
				{"name": "shipping_first_name", "value": "Bonnie"}
				{"name": "shipping_last_name", "value": "Wiseman"}
				{"name": "shipping_address", "value": "3900 Simpson Avenue"}
				{"name": "shipping_city", "value": "Millersville"}
				{"name": "shipping_state", "value": "Pennsylvania"}
				{"name": "shipping_country", "value": "United States of America"}
				{"name": "shipping_zip", "value": "17551"}
				{"name": "shipping_telephone", "value": "717-872-1812"}
				{"name": "billing_first_name", "value": "Bonnie"}
				{"name": "billing_last_name", "value": "Wiseman"}
				{"name": "billing_address", "value": "3900 Simpson Avenue"}
				{"name": "billing_city", "value": "Millersville"}
				{"name": "billing_state", "value": "Pennsylvania"}
				{"name": "billing_country", "value": "United States of America"}
				{"name": "billing_zip", "value": "17551"}
				{"name": "billing_telephone", "value": "717-872-1812"}
				{"name": "card_type", "value": "Visa"}
				{"name": "card_number", "value": "5358831008047065",}
				{"name": "card_name", "value": "Bonnie Wiseman"}
				{"name": "expiry_date_year", "value": "2019", }
				{"name": "expiry_date_month", "value": "12"}
				{"name": "cvv", "value": "232"}
			]

		describe "Confirm Config", ->
			hasProperty = (item, i) -> 
				it "has " + item.name + " '" + item.value + "'", -> expect(purchaseBody.confirm).to.have.property(item.name, item.value)

			hasProperty(item, i) for item, i in [
				{"name": "method", "value": "http"}
				{"name": "http_confirm_url", "value": "http://dev.54.93.185.230.xip.io/twotap/cart/purchaseCallback/"}
				{"name": "http_finished_url", "value": "http://dev.54.93.185.230.xip.io/twotap/cart/purchaseCallback/"}
			]
