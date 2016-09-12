l = console.log
j = require('circular-json').stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapCBCDataProvider.js')
expect = require('chai').expect



describe "040. Observable Collection", ->
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
			beforeEach -> service.clickOption(product.required_fields[0].observableValues[1])
			it "option 1 has selected property", -> expect(field).to.have.property('selected')
			it "selected is a SelectOneModelOption", -> expect(field.selected).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)
			it "option 1 has selected.text 'Style: Girls Tee'", -> expect(field.selected).to.have.property('text', 'Style: Girls Tee')
			# it "has 5 observableValues for option 2", -> expect(product.required_fields[1].observableValues).to.have.length(5)
			it "has 0 observableValues for option 3", -> expect(product.required_fields[2].observableValues).to.have.length(0)

			somoText = (text, i) -> it "[" + i + "] text '" + text + "'", -> expect(product.required_fields[1].observableValues[i]).to.have.property('text', text)
			
			describe "option 2", ->
				it "has 5 observableValues", -> expect(product.required_fields[1].observableValues).to.have.length(5)
				somoText(item, i) for item, i in ["Color: Snow", "Color: Sky Blue", "Color: Gray Granite", "Color: Soft Pink", "Color: Light Lemon"]

			describe "clicking on option 1 - Guys", ->
				beforeEach -> service.clickOption(product.required_fields[0].observableValues[0])
				it "has 5 observableValues", -> expect(product.required_fields[1].observableValues).to.have.length(5)
				somoText(item, i) for item, i in ["Color: White", "Color: Heather Gray", "Color: Light Blue", "Color: Charcoal", "Color: Sand"]

		describe "clicking on option 2 - Sky Blue", ->
			beforeEach -> 
				service.clickOption(product.required_fields[0].observableValues[1])
				service.clickOption(product.required_fields[1].observableValues[1])			

			it "option 1 has selected property", -> expect(product.required_fields[0]).to.have.property('selected')
			it "option 1 has selected.text 'Style: Girls Tee'", -> expect(product.required_fields[0].selected).to.have.property('text', 'Style: Girls Tee')

			it "option 2 has selected property", -> expect(product.required_fields[1]).to.have.property('selected')
			it "option 2 has selected.text 'Color: Sky Blue'", -> expect(product.required_fields[1].selected).to.have.property('text', 'Color: Sky Blue')

			it "has 4 observableValues for option 3", -> expect(product.required_fields[2].observableValues).to.have.length(4)
			
		describe "clicking on option 3 - Medium", ->
			beforeEach -> 
				service.clickOption(product.required_fields[0].observableValues[1])
				service.clickOption(product.required_fields[1].observableValues[1])			
				service.clickOption(product.required_fields[2].observableValues[1])			

			it "option 1 has selected property", -> expect(product.required_fields[0]).to.have.property('selected')
			it "option 1 has selected.text 'Style: Girls Tee'", -> expect(product.required_fields[0].selected).to.have.property('text', 'Style: Girls Tee')

			it "option 2 has selected property", -> expect(product.required_fields[1]).to.have.property('selected')
			it "option 2 has selected.text 'Color: Sky Blue'", -> expect(product.required_fields[1].selected).to.have.property('text', 'Color: Sky Blue')

			it "option 3 has selected property", -> expect(product.required_fields[2]).to.have.property('selected')
			it "option 3 has selected.text 'Size: Medium'", -> expect(product.required_fields[2].selected).to.have.property('text', 'Size: Medium')
