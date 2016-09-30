dp = require('../../src/twotapJSONDataProvider.js')
jf = require('jsonfile')
path = require('path')


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

fixtureFile = "./fixtures/purchase_57ee7a4f5e7e9a403cde5e02.json"

chalk = require('chalk')
chalk.enabled = true

###
# Purchase

* Takes in a purchase, userDetails, callbackConfig
* Returns a purchase object if no errors are thrown
* The purchase object is then sent to Magento **Data Provider**
* Magento respond with the purchase ID **Data Provider**
* We then poll against that purchase ID **Data Provider**
* Then finally we are handed a purchaseRequest object
###

describe "075. Purchase Site Models", ->

	fixture = undefined
	service = undefined
	purchase = undefined
	purchaseObject = undefined

	beforeEach ->
		service = new dp.JSONDataProvider()
		new Promise((c, e)->
			jf.readFile(path.resolve(__dirname, fixtureFile), (err, obj)->
				if(err)
					e(err)
				c(obj)
			)
		)
		.then((fixtureJSONcontents)-> fixture = fixtureJSONcontents
		).then(()->
			service.PrePurchaseResponse.getPrePurchaseResponse(fixture)
		).then((arr)-> 
			purchase = arr[0]
		).then(()->
			service.PurchaseResponse.getPurchaseResponse(purchase)
		).then((arr)-> 
			purchaseObject = arr[0]
		)

	afterEach ->
		fixture = undefined
		service = undefined
		purchase = undefined
		purchaseObject = undefined

	it "fixture is loaded", -> expect(fixture).to.not.equal(undefined)
	it "purchase is a PrePurchaseModel", -> expect(purchase).to.be.instanceOf(Twotapjs.Models.PrePurchaseModel)
	it "purchaseObject is a PurchaseModel", -> expect(purchaseObject).to.be.instanceOf(Twotapjs.Models.PurchaseModel)

	describe "PurchaseSiteModel", ->
		site = undefined
		beforeEach -> site = purchaseObject.sites[0]

		it "site is a PurchaseSiteModel", -> expect(site).to.be.instanceOf(Twotapjs.Models.PurchaseSiteModel)
		it "has order_id 'null'", -> expect(site).to.have.property("order_id", null)
		it "has status 'done'", -> expect(site).to.have.property("status", "done")
		it "has id '529327e055a0f957d5000002'", -> expect(site).to.have.property('id', '529327e055a0f957d5000002')

		describe "prices", ->
			it "has property", -> expect(site).to.have.property('prices')
			it "has sales_tax '$41.40'", -> expect(site.prices).to.have.property("sales_tax", "$41.40")
			it "has shipping_price 'Free'", -> expect(site.prices).to.have.property("shipping_price", "Free")
			it "has final_price '$731.36'", -> expect(site.prices).to.have.property("final_price", "$731.36")

		describe "info", ->
			it "has property", -> expect(site).to.have.property('info')
			it "has url 'bestbuy.com'", -> expect(site.info).to.have.property("url", "bestbuy.com")
			it "has name 'BestBuy'", -> expect(site.info).to.have.property("name", "BestBuy")
			it "has logo", -> expect(site.info).to.have.property("logo")

		describe "details", ->
			it "has property", -> expect(site).to.have.property('details')

	describe "PurchaseProductModel", ->
		product = undefined
		site = undefined
		beforeEach -> 
			site = purchaseObject.sites[0]
			product = site.products[0]

		it "site has 4 products", -> expect(site.products).to.have.length(4)
		it "has id '0224eaf5a38a10db8b48090ad645a098'", -> expect(product).to.have.property("id", "0224eaf5a38a10db8b48090ad645a098")
		

		it "has title 'BIC America - 10\" 350-Watt Powered Subwoofer - Black'", -> expect(product).to.have.property("title", "BIC America - 10\" 350-Watt Powered Subwoofer - Black")
		it "has price '$169.99'", -> expect(product).to.have.property("price", "$169.99")
		it "has weight '17322.870361970425'", -> expect(product).to.have.property("weight", "17322.870361970425")
		it "has pickup_support 'true'", -> expect(product).to.have.property("pickup_support", true)
		it "has original_price 'null'", -> expect(product).to.have.property("original_price", null)
		it "has discounted_price 'null'", -> expect(product).to.have.property("discounted_price", null)
		it "has status 'done'", -> expect(product).to.have.property("status", "done")
		
		it "has image", -> expect(product).to.have.property("image")
		it "has clean_url", -> expect(product).to.have.property("clean_url")
		it "has original_url", -> expect(product).to.have.property("original_url")
		it "has url", -> expect(product).to.have.property("url")
		it "has description", -> expect(product).to.have.property("description")
		
		it "has required_field_names", -> expect(product).to.have.property("required_field_names")
		it "required_field_names length 0", -> expect(product.required_field_names).to.have.length(0)
		it "has alt_images", -> expect(product).to.have.property("alt_images")
		it "alt_images length 4", -> expect(product.alt_images).to.have.length(4)
		it "has categories", -> expect(product).to.have.property("categories")
		it "categories length 5", -> expect(product.categories).to.have.length(5)

		describe "input_fields", ->
			it "exists", -> expect(product).to.have.property("input_fields")
			it "has quantity '1'", -> expect(product.input_fields, "1")
