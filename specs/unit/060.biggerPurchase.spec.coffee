dp = require('../../src/twotapJSONDataProvider.js')
fixture = require('./fixtures/57e1692c66040bb91bae0192.json')
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

describe "060.Bigger Purchase", ->

	service = undefined
	cart = undefined

	beforeEach ->
		service = new dp.JSONDataProvider()
		service.GetCart(fixture).then (result)-> cart = result

	it "should be CartModel", -> expect(cart).to.be.instanceOf(Twotapjs.Models.CartModel)

	describe "Clicking Options", ->
		checkOption = (item, i) ->
			it "Has site[" + item.siteIndex + "].add_to_cart[" + item.productIndex + "].required_fields[" + item.optionIndex + "].selected.text '" + item.expectedValueName + "'", ->
				expect(cart.sites[item.siteIndex].add_to_cart[item.productIndex].required_fields[item.optionIndex]).to.have.property('selected')
				expect(cart.sites[item.siteIndex].add_to_cart[item.productIndex].required_fields[item.optionIndex]).to.have.property('name', item.expectedOptionName)
				expect(cart.sites[item.siteIndex].add_to_cart[item.productIndex].required_fields[item.optionIndex].selected).to.have.property('text', item.expectedValueName)

		selectOption = (item, i) -> 
				service.clickOption(cart.sites[item.siteIndex].add_to_cart[item.productIndex].required_fields[item.optionIndex].observableValues[item.valueIndex])
		
		testData = [
			# Hot Topic - Of Mice And Men
			{'siteIndex': 0, 'productIndex': 0, 'optionIndex': 0, 'valueIndex': 3, 'expectedOptionName': 'size', 'expectedValueName': 'XL'}
			{'siteIndex': 0, 'productIndex': 0, 'optionIndex': 1, 'valueIndex': 3, 'expectedOptionName': 'quantity', 'expectedValueName': 4}
			# Hot Topic - RWBY
			{'siteIndex': 0, 'productIndex': 1, 'optionIndex': 0, 'valueIndex': 2, 'expectedOptionName': 'size', 'expectedValueName': 'MD'}
			{'siteIndex': 0, 'productIndex': 1, 'optionIndex': 1, 'valueIndex': 1, 'expectedOptionName': 'quantity', 'expectedValueName': 2}
			# Thinkgeek - BB8
			{'siteIndex': 1, 'productIndex': 0, 'optionIndex': 0, 'valueIndex': 0, 'expectedOptionName': 'quantity', 'expectedValueName': 1}
			# NFL Baltimore
			{'siteIndex': 2, 'productIndex': 0, 'optionIndex': 0, 'valueIndex': 1, 'expectedOptionName': 'color', 'expectedValueName': 'Purple'}
			{'siteIndex': 2, 'productIndex': 0, 'optionIndex': 1, 'valueIndex': 0, 'expectedOptionName': 'size', 'expectedValueName': 'S'}
			{'siteIndex': 2, 'productIndex': 0, 'optionIndex': 2, 'valueIndex': 1, 'expectedOptionName': 'quantity', 'expectedValueName': 2}
		]

		beforeEach -> selectOption(item, i) for item, i in testData

		checkOption(item, i) for item, i in testData

		describe "Purchase", ->
			purchaseBody = undefined

			CARTID = "57e1692c66040bb91bae0192"

			# Site IDS
			HOTTOPICID = "52d3d515ce04fa310b00000c"
			THINKGEEKID = "53e35c8dce04fa89f1000050"
			NFLID = "53ba9e00ce04fa371a000012"

			# Product IDs
			MICEID = "8e2027cfd423bd8be79ba7e48d967fb8"
			RWBYID = "476d4043658f7e78211582b8cd134769"
			BBEIGHTID = "f1bec620a2d14a1a0712f8084afa4621"
			BALTIMOREID = "ce87a487ae950fbc8e94e6c073c74ce6"

			beforeEach -> service.Purchase(cart, userDetails, confirmConfig).then((pb)-> purchaseBody = pb)

			it "has the cart_id", -> expect(purchaseBody).to.have.property('cart_id', CARTID)
			it "has a products property", -> expect(purchaseBody).to.have.property('products')
			it "length 4", -> expect(purchaseBody.products).to.have.length(4)
			it "has test_mode 'fake_confirm'", -> expect(purchaseBody).to.have.property('test_mode', 'fake_confirm')


			describe "Hot Topic Site " + HOTTOPICID, ->
				it "has the HOTTOPICID as object key", -> expect(purchaseBody.fields_input).to.have.property(HOTTOPICID)
				it "has an addToCart object", -> expect(purchaseBody.fields_input[HOTTOPICID]).to.have.property('addToCart')
				
				describe "Product " + MICEID, ->
					it "has the MICEID as an object key", -> expect(purchaseBody.fields_input[HOTTOPICID].addToCart).to.have.property(MICEID)
					it "has 2 keys", -> expect(Object.keys(purchaseBody.fields_input[HOTTOPICID].addToCart[MICEID])).to.have.length(2)
					it "has size 'XL'", -> expect(purchaseBody.fields_input[HOTTOPICID].addToCart[MICEID]).to.have.property('size', 'XL')
					it "has quantity 4", -> expect(purchaseBody.fields_input[HOTTOPICID].addToCart[MICEID]).to.have.property('quantity', 4)

				describe "Product " + RWBYID, ->
					it "has the RWBYID as an object key", -> expect(purchaseBody.fields_input[HOTTOPICID].addToCart).to.have.property(RWBYID)
					it "has 2 keys", -> expect(Object.keys(purchaseBody.fields_input[HOTTOPICID].addToCart[RWBYID])).to.have.length(2)
					it "has size 'MD'", -> expect(purchaseBody.fields_input[HOTTOPICID].addToCart[RWBYID]).to.have.property('size', 'MD')
					it "has quantity 2", -> expect(purchaseBody.fields_input[HOTTOPICID].addToCart[RWBYID]).to.have.property('quantity', 2)

			describe "Thinkgeek Site " + THINKGEEKID, ->
				it "has the THINKGEEKID as object key", -> expect(purchaseBody.fields_input).to.have.property(THINKGEEKID)
				it "has an addToCart object", -> expect(purchaseBody.fields_input[THINKGEEKID]).to.have.property('addToCart')
				
				describe "Product " + BBEIGHTID, ->
					it "has the BBEIGHTID as an object key", -> expect(purchaseBody.fields_input[THINKGEEKID].addToCart).to.have.property(BBEIGHTID)
					it "has 1 keys", -> expect(Object.keys(purchaseBody.fields_input[THINKGEEKID].addToCart[BBEIGHTID])).to.have.length(1)
					it "has quantity 1", -> expect(purchaseBody.fields_input[THINKGEEKID].addToCart[BBEIGHTID]).to.have.property('quantity', 1)

			describe "Thinkgeek Site " + NFLID, ->
				it "has the NFLID as object key", -> expect(purchaseBody.fields_input).to.have.property(NFLID)
				it "has an addToCart object", -> expect(purchaseBody.fields_input[NFLID]).to.have.property('addToCart')
				
				describe "Product " + BALTIMOREID, ->
					it "has the BALTIMOREID as an object key", -> expect(purchaseBody.fields_input[NFLID].addToCart).to.have.property(BALTIMOREID)
					it "has 3 keys", -> expect(Object.keys(purchaseBody.fields_input[NFLID].addToCart[BALTIMOREID])).to.have.length(3)
					it "has color 'Purple'", -> expect(purchaseBody.fields_input[NFLID].addToCart[BALTIMOREID]).to.have.property('color', 'Purple')
					it "has size 'S'", -> expect(purchaseBody.fields_input[NFLID].addToCart[BALTIMOREID]).to.have.property('size', 'S')
					it "has quantity 2", -> expect(purchaseBody.fields_input[NFLID].addToCart[BALTIMOREID]).to.have.property('quantity', 2)

			describe "User Options (noauthCheckout) for", ->
				hasProperty = (item, siteId) -> it "has " + item.name + " '" + item.value + "'", -> expect(purchaseBody.fields_input[siteId].noauthCheckout).to.have.property(item.name, item.value)

				checkSite = (siteId)-> hasProperty(item, siteId) for item in Object.keys(userDetails).map((key)->return {'name': key, 'value': userDetails[key]})

				describe "Site: Hot Topic (" + HOTTOPICID + ")", -> checkSite(HOTTOPICID)
				describe "Site: Thinkgeek (" + THINKGEEKID + ")", -> checkSite(THINKGEEKID)
				describe "Site: NFL (" + NFLID + ")", -> checkSite(NFLID)

			describe "Confirm Config", ->
				hasProperty = (item, i) -> it "has " + item.name + " '" + item.value + "'", -> expect(purchaseBody.confirm).to.have.property(item.name, item.value)

				hasProperty(item, i) for item, i in [
					{"name": "method", "value": "http"}
					{"name": "http_confirm_url", "value": "http://dev.54.93.185.230.xip.io/twotap/cart/purchaseCallback/"}
					{"name": "http_finished_url", "value": "http://dev.54.93.185.230.xip.io/twotap/cart/purchaseCallback/"}
				]

			# it "prints", -> p purchaseBody