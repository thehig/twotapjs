l = console.log
j = require('circular-json').stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapCBCDataProvider.js')
expect = require('chai').expect



describe "045. Quantity", ->
	service = new dp.CallBackCatcherDataProvider()

	# Set up a fake server to respond on the given URL with the given object
	#  Note: Only calls to the provided URL will succeed. Everything else will 404
	fakeServer = undefined
	before -> 
		fakeServer = require('./fixtures/fixture_sinon_wrapper')("http://callbackcatcher.meteorapp.com/search/body.cart_id=573defe0a5af06fc49ddd0b8", require('./fixtures/573defe0a5af06fc49ddd0b8.json'), 'once')
	after ->
		# Restore the HTTP service afterward so other tests dont break
		fakeServer.restore()

	describe "ID 573defe0a5af06fc49ddd0b8", ->
		cart = undefined
		site = undefined
		product = undefined
		field = undefined

		beforeEach (done) -> 
			service.GetCart("573defe0a5af06fc49ddd0b8")
				.then (result)->
					cart = result
					site = cart.sites[14]
					product = site.add_to_cart[0]
					field = product.required_fields[3]
				.then(
					() -> done()
					(err)-> done(err)
				)

		it "name 'quantity'", -> expect(field).to.have.property('name', 'quantity')
		it "instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
		it "values length 10", -> expect(field.values).to.have.length(10)
		it "has observableValues", -> expect(field).to.have.property('observableValues')

		checkValue = (text, i) -> it "[" + i + "] text '" + text + "'", -> expect(field.observableValues[i]).to.have.property('text', text)
			
		describe "quantity", ->
			it "has 10 observableValues", -> expect(field.observableValues).to.have.length(10)
			checkValue(item, i) for item, i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

		describe "click", ->
			beforeEach -> 
				service.clickOption(field.observableValues[1])

			it "has selected property", -> expect(field).to.have.property('selected')
			it "has selected.text '2'", -> expect(field.selected).to.have.property('text', 2)

