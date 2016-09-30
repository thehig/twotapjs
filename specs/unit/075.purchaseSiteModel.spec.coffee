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

	# it "service has PrePurchaseResponse", -> expect(service).to.have.property('PrePurchaseResponse')
	# it "PrePurchaseResponse has getPrePurchaseResponse", -> expect(service.PrePurchaseResponse).to.have.property('getPrePurchaseResponse')

	# describe "PrePurchaseResponse.getPrePurchaseResponse", ->
	# 	beforeEach ->
	# 		service.PrePurchaseResponse.getPrePurchaseResponse(fixture).then(
	# 			(arr)-> purchase = arr[0]
	# 		)

	# 	it "is a PrePurchaseModel", -> expect(purchase).to.be.instanceOf(Twotapjs.Models.PrePurchaseModel)
	# 	it "has purchase_id - '57ee7a4f5e7e9a403cde5e02'", -> expect(purchase).to.have.property('purchase_id', '57ee7a4f5e7e9a403cde5e02')
	# 	it "has message", -> expect(purchase).to.have.property('message')
	# 	it "has updated_at", -> expect(purchase).to.have.property('updated_at')

	# 	describe "updated_at", ->
	# 		# "updated_at": "2016-09-30 14:50:14"
	# 		it "is a DateTime", -> 
	# 			expect(purchase.updated_at).to.be.instanceOf(Date)
	# 			# console.log(chalk.yellow("Updated At: " + purchase.updated_at.toUTCString()) + chalk.red(" Moda is 1 hour behind GMT"))
	# 		it "has year '2016'", -> expect(purchase.updated_at.getFullYear()).to.equal(2016)
	# 		it "has month '8' ** One Low **", -> expect(purchase.updated_at.getMonth()).to.equal(8) # Start at 0
	# 		it "has date '30'", -> expect(purchase.updated_at.getDate()).to.equal(30)
	# 		it "has hour '14'", -> expect(purchase.updated_at.getHours()).to.equal(14)
	# 		it "has minute '50'", -> expect(purchase.updated_at.getMinutes()).to.equal(50)
	# 		it "has second '14'", -> expect(purchase.updated_at.getSeconds()).to.equal(14)

	# 	describe "PurchaseResponse.getPurchaseResponse", ->
	# 		it "service has PurchaseResponse", -> expect(service).to.have.property('PurchaseResponse')
	# 		it "PurchaseResponse has getPurchaseResponse", -> expect(service.PurchaseResponse).to.have.property('getPurchaseResponse')
	# 		describe "calls", ->
	# 			purchaseObject = undefined
	# 			beforeEach ->
	# 				service.PurchaseResponse.getPurchaseResponse(purchase).then(
	# 					(arr)-> purchaseObject = arr[0]
	# 				)

	# 			afterEach ->
	# 				purchaseObject = undefined

	# 			it "is a PurchaseModel", -> expect(purchaseObject).to.be.instanceOf(Twotapjs.Models.PurchaseModel)
	# 			it "has purchase_id - '57ee7a4f5e7e9a403cde5e02'", -> expect(purchaseObject).to.have.property('purchase_id', '57ee7a4f5e7e9a403cde5e02')

	# 			it "has destination 'domestic'", -> expect(purchaseObject).to.have.property('destination', 'domestic')
	# 			it "has message 'done'", -> expect(purchaseObject).to.have.property("message", "done")
	# 			it "has confirm_with_user 'false'", -> expect(purchaseObject).to.have.property("confirm_with_user", false)
	# 			it "has test_mode 'fake_confirm'", -> expect(purchaseObject).to.have.property("test_mode", "fake_confirm")
	# 			it "has notes 'undefined'", -> expect(purchaseObject).to.have.property("notes", undefined)
	# 			it "has used_profiles 'undefined'", -> expect(purchaseObject).to.have.property("used_profiles", undefined)
	# 			it "has session_finishes_at '1475247587858'", -> 
	# 				expect(purchaseObject.session_finishes_at.getTime()).to.equal(1475247587858)
	# 				# console.log(chalk.yellow("Session Finishes At: " + purchaseObject.session_finishes_at.toUTCString()))
	# 			it "has pending_confirm 'true'", -> expect(purchaseObject).to.have.property("pending_confirm", true)

	# 			it "has total_prices", -> expect(purchaseObject).to.have.property("total_prices")
	# 			describe "total_prices", ->
	# 				it "has sales_tax '$41.40'", -> expect(purchaseObject.total_prices).to.have.property("sales_tax", '$41.40')
	# 				it "has shipping_price '$0.00'", -> expect(purchaseObject.total_prices).to.have.property("shipping_price", '$0.00')
	# 				it "has final_price '$731.36'", -> expect(purchaseObject.total_prices).to.have.property("final_price", '$731.36')

	# 			describe "created_at", ->
	# 				# "created_at": "2016-09-30T14:44:32.108Z",

	# 				it "is a DateTime", -> 
	# 					expect(purchaseObject.created_at).to.be.instanceOf(Date)
	# 					# console.log(chalk.yellow("Session Created At: " + purchaseObject.created_at.toUTCString()))
	# 				it "has year '2016'", -> expect(purchaseObject.created_at.getFullYear()).to.equal(2016)
	# 				it "has month '8' ** One Low **", -> expect(purchaseObject.created_at.getMonth()).to.equal(8) # Start at 0
	# 				it "has date '30'", -> expect(purchaseObject.created_at.getDate()).to.equal(30)
	# 				it "has hour '15' ** One High **", -> expect(purchaseObject.created_at.getHours()).to.equal(15) # Off by one
	# 				it "has minute '44'", -> expect(purchaseObject.created_at.getMinutes()).to.equal(44)
	# 				it "has second '32'", -> expect(purchaseObject.created_at.getSeconds()).to.equal(32)		


