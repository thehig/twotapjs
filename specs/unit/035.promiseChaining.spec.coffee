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
		

		describe "returns", ->
			rawNewCart = undefined
			newCart = undefined

			before (done) -> service.GetCart('573defe0a5af06fc49ddd0b8').then (chainedCart) -> 
				rawNewCart = chainedCart
				done()

			beforeEach ->
				newCart = deepcopy(rawNewCart)

			it "a promise", -> expect(service.GetCart()).to.have.property('then')
			it "a CartDataModel object", -> expect(newCart).to.be.instanceOf(Twotapjs.Models.CartModel)

			describe "compared with Cart.getCart()", ->
				rawOldCart = undefined
				oldCart = undefined

				before (done) ->
					service.Cart.getCart('573defe0a5af06fc49ddd0b8').then (simpleCart) -> 
						rawOldCart = simpleCart[0]
						done()

				beforeEach ->
					oldCart = deepcopy(rawOldCart)

				it "instance of CartModel", ->
					expect(oldCart).to.be.instanceOf(Twotapjs.Models.CartModel)
					expect(newCart).to.be.instanceOf(Twotapjs.Models.CartModel)

				it "same id", -> expect(oldCart.id).to.equal(newCart.id)
				it "same sites length", -> expect(oldCart.sites.length).to.equal(newCart.sites.length)

			describe "chained promises that", ->
				it "return the CartModel directly", -> expect(newCart).to.be.instanceOf(Twotapjs.Models.CartModel)
				it "process the products required_fields automatically (see 030)", -> expect(newCart.sites[14].add_to_cart[0].required_fields[1].values).to.have.length(10)