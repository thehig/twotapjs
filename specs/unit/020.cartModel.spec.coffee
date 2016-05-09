l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixture = require('./fixtures/hugecart.fixture.js');

describe "020. Cart Fixture", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.SampleDataProvider()
		service.Cart.setCart(deepcopy(fixture))
			.then service.Cart.getCart
			.then (cart)-> data = cart[0]
			.then(
				() -> done()
				(err)-> done(err)
			)
	it "should have returned data", -> expect(data).to.not.be.undefined
	it "should be instance of CartModel", -> expect(data).to.be.instanceOf(Twotapjs.Models.CartModel)


	it "user_id of 'undefined'", -> expect(data).to.have.property("user_id", undefined)
	it "cart_id of '570ce00581fe1d62245836fd'", -> expect(data).to.have.property("cart_id", "570ce00581fe1d62245836fd")
	it "country of 'us'", -> expect(data).to.have.property("country", "us")
	it "message of 'has_failures'", -> expect(data).to.have.property("message", "has_failures")
	it "description containing 'out of stock'", -> expect(data.description).to.contain("out of stock")
	it "unknown_urls length '5'", -> expect(data.unknown_urls).to.have.length(5)

	it "sites length '23'", -> expect(data.sites).to.have.length(23)
	it "[0] instance of SiteModel", -> expect(data.sites[0]).to.be.instanceOf(Twotapjs.Models.SiteModel)
