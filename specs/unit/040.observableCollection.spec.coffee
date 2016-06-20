l = console.log
j = require('circular-json').stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect



describe.only "040. Observable Collection", ->
	service = new dp.CallBackCatcherDataProvider()

	# Set up a fake server to respond on the given URL with the given object
	#  Note: Only calls to the provided URL will succeed. Everything else will 404
	fakeServer = undefined
	before -> 
		fakeServer = require('./fixtures/fixture_sinon_wrapper')("http://callbackcatcher.meteorapp.com/search/body.cart_id=573defe0a5af06fc49ddd0b8", require('./fixtures/573defe0a5af06fc49ddd0b8.json'), 'none')
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
					field = product.required_fields[0]
				.then(
					() -> done()
					(err)-> done(err)
				)


		describe "field 0", ->
			it "should have observableValues property", -> expect(field).to.have.property('observableValues')
			it "should be an array", -> expect(field.observableValues).to.be.an('Array')
			it "should have length 2", -> expect(field.observableValues).to.have.length(2)

		describe "default state", ->
			it "has 2 observableValues for option 1", -> expect(product.required_fields[0].observableValues).to.have.length(2)
			it "has 0 observableValues for option 2", -> expect(product.required_fields[1].observableValues).to.have.length(0)
			it "has 0 observableValues for option 3", -> expect(product.required_fields[2].observableValues).to.have.length(0)
			
		describe "clickOption", ->
			it "service should have property 'clickOption'", -> expect(service).to.have.property('clickOption')
			it "should be a function", -> expect(service.clickOption).to.be.a('function')
			it "throws an error if parameter is not SelectOneModelOption", -> expect(-> service.clickOption({})).to.throw(/not a SelectOneModelOption/)

		describe "clicking on option 1 - Girls", ->
			beforeEach -> service.clickOption(field.observableValues[1])
			it "option 1 has selected property", -> expect(field).to.have.property('selected')
			it "selected is a SelectOneModelOption", -> expect(field.selected).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)
			it "option 1 has selected.text 'Style: Girls Tee'", -> expect(field.selected).to.have.property('text', 'Style: Girls Tee')
			it "has 5 observableValues for option 2", -> expect(product.required_fields[1].observableValues).to.have.length(5)
			it "has 0 observableValues for option 3", -> expect(product.required_fields[2].observableValues).to.have.length(0)
			
		describe "clicking on option 2 - Sky Blue", ->
			it.skip "option 1 has selected property", -> expect(false).to.be.true
			it.skip "option 1 is Style: Girls Tee", -> expect(false).to.be.true
			it.skip "option 2 has selected property", -> expect(false).to.be.true
			it.skip "option 2 is Color: Sky Blue", -> expect(false).to.be.true
			it.skip "option 3 has 4 options", -> expect(false).to.be.true
			
		describe "clicking on option 3 - Medium", ->
			it.skip "option 1 has selected property", -> expect(false).to.be.true
			it.skip "option 1 is Style: Girls Tee", -> expect(false).to.be.true
			it.skip "option 2 has selected property", -> expect(false).to.be.true
			it.skip "option 2 is Color: Sky Blue", -> expect(false).to.be.true
			it.skip "option 3 has selected property", -> expect(false).to.be.true
			it.skip "option 3 is Size: Medium", -> expect(false).to.be.true
