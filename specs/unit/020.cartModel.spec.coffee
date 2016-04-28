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
