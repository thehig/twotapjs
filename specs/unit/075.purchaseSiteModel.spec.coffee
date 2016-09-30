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

#  Inner Sites collection:
###
{
	"sites": {
		"529327e055a0f957d5000002": {
			"info": {
				"url": "bestbuy.com",
				"name": "BestBuy",
				"logo": "https://px.twotap.com/unsafe/https%3A//core.twotap.com/system/sites/logos/5293/27e0/55a0/f957/d500/0002/small/529327e055a0f957d5000002.png%3F1475219185378"
			},
			"prices": {
				"sales_tax": "$41.40",
				"shipping_price": "Free",
				"final_price": "$731.36"
			},
			"details": {},
			"order_id": null,
			"products": {
				"0224eaf5a38a10db8b48090ad645a098": {
					"title": "BIC America - 10\" 350-Watt Powered Subwoofer - Black",
					"price": "$169.99",
					"image": "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_sa.jpg;maxHeight=550;maxWidth=642",
					"alt_images": ["http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_sa.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_ra.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_ba.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523cv11a.jpg;maxHeight=550;maxWidth=642"],
					"description": "This 10&quot; subwoofer features 350 watts of peak power for explosive bass with reduced distortion and a heavy-duty, long-excursion polypropylene woofer cone for powerful sound.",
					"categories": ["Best Buy", "Audio", "Home Audio", "Speakers", "Subwoofer Speakers"],
					"weight": "17322.870361970425",
					"pickup_support": true,
					"required_field_names": [],
					"url": "http://www.bestbuy.com/site/bic-america-10-350-watt-powered-subwoofer/2750523.p;jsessionid=CC5512A5532CE5CA0598B69DD3DFCC8D.bbolsp-app01-101",
					"original_price": null,
					"discounted_price": null,
					"status": "done",
					"clean_url": "http://www.bestbuy.com/site/bic-america-10-350-watt-powered-subwoofer/2750523.p;jsessionid=CC5512A5532CE5CA0598B69DD3DFCC8D.bbolsp-app01-101",
					"original_url": "http://www.bestbuy.com/site/bic-america-10-350-watt-powered-subwoofer/2750523.p;jsessionid=CC5512A5532CE5CA0598B69DD3DFCC8D.bbolsp-app01-101",
					"input_fields": {
						"quantity": "1"
					}
				},
				"0dbc7ab2fe921bc1bae1c12c6bd783bd": {
					"original_url": "http://www.bestbuy.com/site/bic-america-rtr-series-12-200-watt-powered-subwoofer/2750435.p;jsessionid=46F854A8C95B323572D3CDD03742F301.bbolsp-app02-104",
					"clean_url": "http://www.bestbuy.com/site/bic-america-rtr-series-12-200-watt-powered-subwoofer/2750435.p;jsessionid=46F854A8C95B323572D3CDD03742F301.bbolsp-app02-104",
					"status": "done",
					"discounted_price": null,
					"original_price": null,
					"url": "http://www.bestbuy.com/site/bic-america-rtr-series-12-200-watt-powered-subwoofer/2750435.p;jsessionid=46F854A8C95B323572D3CDD03742F301.bbolsp-app02-104?tt=1",
					"required_field_names": [],
					"pickup_support": true,
					"weight": "15172.820466297742",
					"categories": ["Best Buy", "Audio", "Home Audio", "Speakers", "Subwoofer Speakers"],
					"description": "This 12&quot; subwoofer features RCA and speaker-level inputs for a simple connection and adjustable crossover and volume controls to customize your sound. The 200-watt amplifier with soft clipping provides clean, powerful sound.",
					"alt_images": ["http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750435_sa.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750435_ra.jpg;maxHeight=550;maxWidth=642"],
					"image": "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750435_sa.jpg;maxHeight=550;maxWidth=642",
					"price": "$174.99",
					"title": "BIC America - RTR Series 12\" 200-Watt Powered Subwoofer - Black",
					"input_fields": {
						"quantity": "1"
					}
				},
				"08fbfde5e43a28b989bb8a66d1b1afeb": {
					"original_url": "http://www.bestbuy.com/site/bic-america-10-350-watt-powered-subwoofer/2750523.p;jsessionid=CC5512A5532CE5CA0598B69DD3DFCC8D.bbolsp-app01-101",
					"clean_url": "http://www.bestbuy.com/site/bic-america-10-350-watt-powered-subwoofer/2750523.p;jsessionid=CC5512A5532CE5CA0598B69DD3DFCC8D.bbolsp-app01-101",
					"status": "done",
					"discounted_price": null,
					"original_price": null,
					"url": "http://www.bestbuy.com/site/bic-america-10-350-watt-powered-subwoofer/2750523.p;jsessionid=CC5512A5532CE5CA0598B69DD3DFCC8D.bbolsp-app01-101?tt=1",
					"required_field_names": [],
					"pickup_support": true,
					"weight": "17322.870361970425",
					"categories": ["Best Buy", "Audio", "Home Audio", "Speakers", "Subwoofer Speakers"],
					"description": "This 10&quot; subwoofer features 350 watts of peak power for explosive bass with reduced distortion and a heavy-duty, long-excursion polypropylene woofer cone for powerful sound.",
					"alt_images": ["http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_sa.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_ra.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_ba.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523cv11a.jpg;maxHeight=550;maxWidth=642"],
					"image": "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750523_sa.jpg;maxHeight=550;maxWidth=642",
					"price": "$169.99",
					"title": "BIC America - 10\" 350-Watt Powered Subwoofer - Black",
					"input_fields": {
						"quantity": "1"
					}
				},
				"bd1fd5783031baf5fad7e3900e1aadf7": {
					"title": "BIC America - RTR Series 12\" 200-Watt Powered Subwoofer - Black",
					"price": "$174.99",
					"image": "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750435_sa.jpg;maxHeight=550;maxWidth=642",
					"alt_images": ["http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750435_sa.jpg;maxHeight=550;maxWidth=642", "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/2750/2750435_ra.jpg;maxHeight=550;maxWidth=642"],
					"description": "This 12&quot; subwoofer features RCA and speaker-level inputs for a simple connection and adjustable crossover and volume controls to customize your sound. The 200-watt amplifier with soft clipping provides clean, powerful sound.",
					"categories": ["Best Buy", "Audio", "Home Audio", "Speakers", "Subwoofer Speakers"],
					"weight": "15172.820466297742",
					"pickup_support": true,
					"required_field_names": [],
					"url": "http://www.bestbuy.com/site/bic-america-rtr-series-12-200-watt-powered-subwoofer/2750435.p;jsessionid=46F854A8C95B323572D3CDD03742F301.bbolsp-app02-104",
					"original_price": null,
					"discounted_price": null,
					"status": "done",
					"clean_url": "http://www.bestbuy.com/site/bic-america-rtr-series-12-200-watt-powered-subwoofer/2750435.p;jsessionid=46F854A8C95B323572D3CDD03742F301.bbolsp-app02-104",
					"original_url": "http://www.bestbuy.com/site/bic-america-rtr-series-12-200-watt-powered-subwoofer/2750435.p;jsessionid=46F854A8C95B323572D3CDD03742F301.bbolsp-app02-104",
					"input_fields": {
						"quantity": "1"
					}
				}
			},
			"status": "done"
		}
	},
}
###

describe.only "075. Purchase Site Models", ->

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
