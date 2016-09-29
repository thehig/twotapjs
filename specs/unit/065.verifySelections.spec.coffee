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

describe "065.Verify Selections Purchase", ->

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
			# {'siteIndex': 2, 'productIndex': 0, 'optionIndex': 2, 'valueIndex': 1, 'expectedOptionName': 'quantity', 'expectedValueName': 2}
		]

		beforeEach -> selectOption(item, i) for item, i in testData

		checkOption(item, i) for item, i in testData

		describe "Verify", ->
			it "rejects with 'Option not selected'", -> expect(service.Verify(cart)).to.be.rejectedWith("Option not selected");