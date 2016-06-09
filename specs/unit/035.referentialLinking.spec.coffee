l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')



describe.skip "035. Referential Linking", ->
	source = undefined
	service = new dp.CallBackCatcherDataProvider()

	# Set up a fake server to respond on the given URL with the given object
	#  Note: Only calls to the provided URL will succeed. Everything else will 404
	fakeServer = undefined
	before -> 
		fakeServer = require('./fixtures/fixture_sinon_wrapper')("http://callbackcatcher.meteorapp.com/search/body.cart_id=573defe0a5af06fc49ddd0b8", require('./fixtures/573defe0a5af06fc49ddd0b8.json'))
	after ->
		# Restore the HTTP service afterward so other tests dont break
		fakeServer.restore()

	describe "ID 573defe0a5af06fc49ddd0b8", ->
		cart = undefined
		site = undefined
		product = undefined
		
		before (done)->
			service.GetCart("573defe0a5af06fc49ddd0b8")
				.then (cart)->
					# console.log(JSON.stringify(cart))
					source = cart
				.then(
					() -> done()
					(err)-> done(err)
				)

		beforeEach -> 
			cart = deepcopy(source)
			site = cart.sites[14]
			product = site.add_to_cart[0]

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
			it "has 10 values", -> expect(field.values).to.have.length(10)
		describe "required_fields[1][0] (SelectOneModelOption)", ->
			field = undefined
			option = undefined
			beforeEach ->
				field = product.required_fields[1]
				option = field.values[0]

			it "field name 'option 2'", -> expect(field).to.have.property('name', 'option 2')
			it "field instanceof Twotapjs.Models.SelectOneModel", -> expect(field).to.be.instanceof(Twotapjs.Models.SelectOneModel)

			it "option text 'Color: White'", -> expect(option).to.have.property('text', 'Color: White')
			it "option instanceof Twotapjs.Models.SelectOneModelOption", -> expect(option).to.be.instanceof(Twotapjs.Models.SelectOneModelOption)
			
			it "has property 'parent'", -> expect(option).to.have.property('parent')

			describe 'parent', ->
				parent = undefined
				beforeEach -> parent = option.parent

				it "has property _selectOneModel", -> expect(parent).to.have.property('_selectOneModel')
				it "_selectOneModel instanceof Twotapjs.Models.SelectOneModel", -> expect(parent._selectOneModel).to.be.instanceof(Twotapjs.Models.SelectOneModel)
				it "_selectOneModel deepequals field", -> expect(parent._selectOneModel).to.deep.equal(field)


