l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')

describe.only "035. Promise Chaining", ->
	service = new dp.CallBackCatcherDataProvider()

	describe "service.GetCart()", ->
		it "exists", -> expect(service).to.have.property('GetCart')
		it "returns a promise", -> expect(service.GetCart()).to.have.property('then')

		describe "comparison with Cart.getCart()", ->
			sourceA = undefined
			sourceB = undefined

			cartA = undefined
			cartB = undefined
			before (done) ->
				promiseA = service.Cart.getCart('573defe0a5af06fc49ddd0b8').then (simpleCart) -> sourceA = simpleCart[0]
				promiseB = service.GetCart('573defe0a5af06fc49ddd0b8').then (chainedCart) -> sourceB = chainedCart[0]
				WinJS.Promise.join([promiseA, promiseB]).then -> done()

			beforeEach ->
				cartA = deepcopy(sourceA)
				cartB = deepcopy(sourceB)

			it "created both objects", -> 
				expect(cartA).to.not.be.undefined
				expect(cartB).to.not.be.undefined

			it "instances of CartModel", ->
				expect(cartA).to.be.instanceOf(Twotapjs.Models.CartModel)
				expect(cartB).to.be.instanceOf(Twotapjs.Models.CartModel)

			it "has the same id", -> expect(cartA.id).to.equal(cartB.id)