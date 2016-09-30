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
fixture = undefined

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

describe.only "070. Pre-Confirm Response", ->

	service = undefined
	purchase = undefined

	beforeEach ->
		service = new dp.JSONDataProvider()
		new Promise((c, e)->
			jf.readFile(path.resolve(__dirname, fixtureFile), (err, obj)->
				if(err)
					e(err)
				c(obj)
			)
		)
		.then((fixtureJSONcontents)-> fixture = fixtureJSONcontents)
	afterEach ->
		service = undefined
		fixture = undefined

	it "purchase fixture is loaded", -> expect(fixture).to.not.equal(undefined)

	it "service has PrePurchaseResponse", -> expect(service).to.have.property('PrePurchaseResponse')
	it "PrePurchaseResponse has getPrePurchaseResponse", -> expect(service.PrePurchaseResponse).to.have.property('getPrePurchaseResponse')

	describe "PrePurchaseResponse.getPrePurchaseResponse", ->
		beforeEach ->
			service.PrePurchaseResponse.getPrePurchaseResponse(fixture).then(
				(arr)-> purchase = arr[0]
			)

		it "is a PrePurchaseModel", -> expect(purchase).to.be.instanceOf(Twotapjs.Models.PrePurchaseModel)
		it "has purchase_id - '57ee7a4f5e7e9a403cde5e02'", -> expect(purchase).to.have.property('purchase_id', '57ee7a4f5e7e9a403cde5e02')
		it "has message", -> expect(purchase).to.have.property('message')
		it "has updated_at", -> expect(purchase).to.have.property('updated_at')

		describe "updated_at", ->
			# "updated_at": "2016-09-30 14:50:14"
			it "is a DateTime", -> 
				expect(purchase.updated_at).to.be.instanceOf(Date)
				# console.log(chalk.yellow("Updated At: " + purchase.updated_at.toUTCString()) + chalk.red(" Moda is 1 hour behind GMT"))
			it "has year '2016'", -> expect(purchase.updated_at.getFullYear()).to.equal(2016)
			it "has month '8' ** One Low **", -> expect(purchase.updated_at.getMonth()).to.equal(8) # Start at 0
			it "has date '30'", -> expect(purchase.updated_at.getDate()).to.equal(30)
			it "has hour '14'", -> expect(purchase.updated_at.getHours()).to.equal(14)
			it "has minute '50'", -> expect(purchase.updated_at.getMinutes()).to.equal(50)
			it "has second '14'", -> expect(purchase.updated_at.getSeconds()).to.equal(14)

		describe "PurchaseResponse.getPurchaseResponse", ->
			it "service has PurchaseResponse", -> expect(service).to.have.property('PurchaseResponse')
			it "PurchaseResponse has getPurchaseResponse", -> expect(service.PurchaseResponse).to.have.property('getPurchaseResponse')
			describe "calls", ->
				purchaseObject = undefined
				beforeEach ->
					service.PurchaseResponse.getPurchaseResponse(purchase).then(
						(arr)-> purchaseObject = arr[0]
					)

				afterEach ->
					purchaseObject = undefined

				it "is a PurchaseModel", -> expect(purchaseObject).to.be.instanceOf(Twotapjs.Models.PurchaseModel)
				it "has purchase_id - '57ee7a4f5e7e9a403cde5e02'", -> expect(purchaseObject).to.have.property('purchase_id', '57ee7a4f5e7e9a403cde5e02')

				it "has destination 'domestic'", -> expect(purchaseObject).to.have.property('destination', 'domestic')
				it "has message 'done'", -> expect(purchaseObject).to.have.property("message", "done")
				it "has confirm_with_user 'false'", -> expect(purchaseObject).to.have.property("confirm_with_user", false)
				it "has test_mode 'fake_confirm'", -> expect(purchaseObject).to.have.property("test_mode", "fake_confirm")
				it "has notes 'undefined'", -> expect(purchaseObject).to.have.property("notes", undefined)
				it "has used_profiles 'undefined'", -> expect(purchaseObject).to.have.property("used_profiles", undefined)
				it "has session_finishes_at '1475247587858'", -> 
					expect(purchaseObject.session_finishes_at.getTime()).to.equal(1475247587858)
					# console.log(chalk.yellow("Session Finishes At: " + purchaseObject.session_finishes_at.toUTCString()))
				it "has pending_confirm 'true'", -> expect(purchaseObject).to.have.property("pending_confirm", true)

				it "has total_prices", -> expect(purchaseObject).to.have.property("total_prices")
				describe "total_prices", ->
					it "has sales_tax '$41.40'", -> expect(purchaseObject.total_prices).to.have.property("sales_tax", '$41.40')
					it "has shipping_price '$0.00'", -> expect(purchaseObject.total_prices).to.have.property("shipping_price", '$0.00')
					it "has final_price '$731.36'", -> expect(purchaseObject.total_prices).to.have.property("final_price", '$731.36')

				describe "created_at", ->
					# "created_at": "2016-09-30T14:44:32.108Z",

					it "is a DateTime", -> 
						expect(purchaseObject.created_at).to.be.instanceOf(Date)
						# console.log(chalk.yellow("Session Created At: " + purchaseObject.created_at.toUTCString()))
					it "has year '2016'", -> expect(purchaseObject.created_at.getFullYear()).to.equal(2016)
					it "has month '8' ** One Low **", -> expect(purchaseObject.created_at.getMonth()).to.equal(8) # Start at 0
					it "has date '30'", -> expect(purchaseObject.created_at.getDate()).to.equal(30)
					it "has hour '15' ** One High **", -> expect(purchaseObject.created_at.getHours()).to.equal(15) # Off by one
					it "has minute '44'", -> expect(purchaseObject.created_at.getMinutes()).to.equal(44)
					it "has second '32'", -> expect(purchaseObject.created_at.getSeconds()).to.equal(32)		


