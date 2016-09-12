l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapCBCDataProvider.js')
expect = require('chai').expect

describe "035. Referential Linking", ->
	source = undefined
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
		
		beforeEach (done)->
			service.GetCart("573defe0a5af06fc49ddd0b8")
				.then (source)->
					# console.log(JSON.stringify(cart))
					cart = source
					site = cart.sites[14]
					product = site.add_to_cart[0]

				.then(
					() -> done()
					(err)-> done(err)
				)

		describe "site", ->
			it "has property _cart", -> expect(site).to.have.property('_cart')
			it "._cart deepequals cart", -> expect(site._cart).to.deep.equal(cart)
		describe "product", ->
			it "has property _cart", -> expect(product).to.have.property('_cart')
			it "._cart deepequals cart", -> expect(product._cart).to.deep.equal(cart)
			it "has property _site", -> expect(product).to.have.property('_site')
			it "._site deepequals site", -> expect(product._site).to.deep.equal(site)
		describe "required_fields[1] (SelectOneModel)", ->
			field = undefined
			beforeEach ->
				field = product.required_fields[1]
			it "name option 2", -> expect(field).to.have.property('name', 'option 2')
			it "has property _product", -> expect(field).to.have.property('_product')
			it "has property _cart", -> expect(field).to.have.property('_cart')
			it "._cart deepequals cart", -> expect(field._cart).to.deep.equal(cart)
			it "has property _site", -> expect(field).to.have.property('_site')
			it "._site deepequals site", -> expect(field._site).to.deep.equal(site)
			it "has 10 values (Complete list for 'option 2')", -> expect(field.values).to.have.length(10)
		describe "required_fields[1][0] (SelectOneModelOption)", ->
			field = undefined
			option = undefined
			beforeEach ->
				field = product.required_fields[1]
				option = field.values[0]

			it "field name 'option 2'", -> expect(field).to.have.property('name', 'option 2')
			it "field instanceof Twotapjs.Models.SelectOneModel", -> expect(field).to.be.instanceof(Twotapjs.Models.SelectOneModel)
			it "field has 10 values (Complete list for 'option 2')", -> expect(field.values).to.have.length(10)

			it "option text 'Color: White'", -> expect(option).to.have.property('text', 'Color: White')
			it "option instanceof Twotapjs.Models.SelectOneModelOption", -> expect(option).to.be.instanceof(Twotapjs.Models.SelectOneModelOption)

			
			describe "Parent Option", ->			
				# Model    > Option            > Model    > Option
				# option 1 > 'Style: Guys Tee' > option 2 > "Color: White"
				it "option has property 'parentOption'", -> expect(option).to.have.property('parentOption')
				it "option.parentOption instanceof SelectOneModelOption", -> expect(option.parentOption).to.be.instanceof(Twotapjs.Models.SelectOneModelOption)
				it "option.parentOption.text 'Style: Guys Tee'", -> expect(option.parentOption).to.have.property('text', 'Style: Guys Tee')


			describe "Parent Model", ->	
				it "option has property 'parentModel'", -> expect(option).to.have.property('parentModel')
				it "option.parentModel instanceof SelectOneModel", -> expect(option.parentModel).to.be.instanceof(Twotapjs.Models.SelectOneModel)
				it "option.parentModel has 'name' of 'option 2'", -> expect(option.parentModel).to.have.property('name', 'option 2')
				
				# Note: We have 5 values here, but we have 10 above.
				# 	I think this is because in the case below, we're refering directly to the parent selectOneModel which has only the specific elements
				# 	But in the cases above where we have 10, we're looking at the merged list that has every possible element
				it "option.parentModel has 5 values (Specific list for the parent 'option 2')", -> expect(option.parentModel.values).to.have.length(5)

			

