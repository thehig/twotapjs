l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect


describe "027. Promise Chaining", ->
	# Set up a fake server to respond on the given URL with the given object
	#  Note: Only calls to the provided URL will succeed. Everything else will 404
	fakeServer = undefined
	before -> 
		fakeServer = require('./fixtures/fixture_sinon_wrapper')("http://callbackcatcher.meteorapp.com/search/body.cart_id=573defe0a5af06fc49ddd0b8", require('./fixtures/573defe0a5af06fc49ddd0b8.json'), 'once')
	after ->
		# Restore the HTTP service afterward so other tests dont break
		fakeServer.restore()
		
	service = new dp.CallBackCatcherDataProvider()

	describe "service.GetCart()", ->
		it "exists", -> expect(service).to.have.property('GetCart')
		describe "returns", ->
			rawNewCart = undefined
			newCart = undefined

			beforeEach (done) -> service.GetCart('573defe0a5af06fc49ddd0b8').then (chainedCart) -> 
				newCart = chainedCart
				done()

			it "a promise", -> expect(service.GetCart()).to.have.property('then')
			it "a CartDataModel object", -> expect(newCart).to.be.instanceOf(Twotapjs.Models.CartModel)

			describe "compared with Cart.getCart()", ->
				rawOldCart = undefined
				oldCart = undefined

				beforeEach (done) ->
					service.Cart.getCart('573defe0a5af06fc49ddd0b8').then (simpleCart) -> 
						oldCart = simpleCart[0]
						done()

				it "instance of CartModel", ->
					expect(oldCart).to.be.instanceOf(Twotapjs.Models.CartModel)
					expect(newCart).to.be.instanceOf(Twotapjs.Models.CartModel)

				it "same id", -> expect(oldCart.id).to.equal(newCart.id)
				it "same sites length", -> expect(oldCart.sites.length).to.equal(newCart.sites.length)

			describe "chained promises that", ->
				it "return the CartModel directly", -> expect(newCart).to.be.instanceOf(Twotapjs.Models.CartModel)
				it "process the products required_fields automatically (see 030)", -> expect(newCart.sites[14].add_to_cart[0].required_fields[1].values).to.have.length(10)