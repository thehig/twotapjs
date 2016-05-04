l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixture = require('./fixtures/hugecart.fixture.js');

describe.only "025. CallbackCatcher Passthrough", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.CallBackCatcherDataProvider()
		service.Cart.getCart("6nkxSkBNjhTP2EQfg")
			.then (cart)->
				# console.log(JSON.stringify(cart))
				data = cart[0]
			.then(
				() -> done()
				(err)-> done(err)
			)
	it "should have returned data", -> expect(data).to.not.be.undefined
	it "should be instance of CartModel", -> expect(data).to.be.instanceOf(Twotapjs.Models.CartModel)
	
	it "user_id of 'undefined'", -> expect(data).to.have.property("user_id", undefined)
	it "cart_id of '570ce8fcad50615523c511d2'", -> expect(data).to.have.property("cart_id", "570ce8fcad50615523c511d2")
	it "country of 'us'", -> expect(data).to.have.property("country", "us")
	it "message of 'done'", -> expect(data).to.have.property("message", "done")
	it "description containing 'AddToCart has been completed'", -> expect(data.description).to.contain("AddToCart has been completed")

	it "sites length '1'", -> expect(data.sites).to.have.length(1)
	it "[0] instance of SiteModel", -> expect(data.sites[0]).to.be.instanceOf(Twotapjs.Models.SiteModel)