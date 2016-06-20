l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect


describe.only "040. Observable Collection", ->
	source = undefined
	service = new dp.CallBackCatcherDataProvider()

	describe "observableListType", ->
		it "property exists", -> expect(service).to.have.property('observableListType')
		it "is a function", -> expect(service.observableListType).to.be.a('function')
		it "returns an array", -> expect(service.observableListType()).to.be.an('Array')

	# Set up a fake server to respond on the given URL with the given object
	#  Note: Only calls to the provided URL will succeed. Everything else will 404
	fakeServer = undefined
	before -> 
		fakeServer = require('./fixtures/fixture_sinon_wrapper')("http://callbackcatcher.meteorapp.com/search/body.cart_id=573defe0a5af06fc49ddd0b8", require('./fixtures/573defe0a5af06fc49ddd0b8.json'), true)
	after ->
		# Restore the HTTP service afterward so other tests dont break
		fakeServer.restore()

	describe "ID 573defe0a5af06fc49ddd0b8 (Using Sinon wrapper)", ->
		cart = undefined
		site = undefined
		product = undefined
		field = undefined

		beforeEach (done)->
			service.GetCart("573defe0a5af06fc49ddd0b8")
				.then (result)->
					# console.log(JSON.stringify(cart))
					cart = result
					site = cart.sites[14]
					product = site.add_to_cart[0]
					field = product.required_fields[0]
				.then(
					() -> done()
					(err)-> done(err)
				)
			
		describe "field", ->
			it "should have observableValues property", -> expect(field).to.have.property('observableValues')
			it "should be an array", -> expect(field.observableValues).to.be.an('Array')