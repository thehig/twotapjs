l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')

describe "025. CallbackCatcher Passthrough", ->
	source = undefined
	data = undefined
	service = undefined

	before (done)->
		service = new dp.CallBackCatcherDataProvider()
		service.Cart.getCart("570cd91ff9ffdedc6ccbac10")
			.then (cart)-> source = cart[0]
			.then(
				() -> done()
				(err)-> done(err)
			)

	beforeEach ()-> data = deepcopy(source)

	it "should have returned data", -> expect(data).to.not.be.undefined
	it "should be instance of CartModel", -> expect(data).to.be.instanceOf(Twotapjs.Models.CartModel)
	
	it "user_id of 'undefined'", -> expect(data).to.have.property("user_id", undefined)
	it "cart_id of '570cd91ff9ffdedc6ccbac10'", -> expect(data).to.have.property("cart_id", "570cd91ff9ffdedc6ccbac10")
	it "country of 'us'", -> expect(data).to.have.property("country", "us")
	it "message of 'done'", -> expect(data).to.have.property("message", "done")
	it "description containing 'AddToCart has been completed'", -> expect(data.description).to.contain("AddToCart has been completed")

	it "sites length '1'", -> expect(data.sites).to.have.length(1)
	it "[0] instance of SiteModel", -> expect(data.sites[0]).to.be.instanceOf(Twotapjs.Models.SiteModel)