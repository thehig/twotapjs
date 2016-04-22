l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixture = require('./fixtures/product_two.fixture.js');

describe "001. Product Two Fixture", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.DataProvider()
		service.Sample.setProduct(deepcopy(fixture))
			.then service.Sample.getProduct
			.then (product)-> data = product[0]
			.then(
				() -> done()
				(err)-> done(err)
			)

	
	it "title should contain 'Tis But A Scratch'", -> expect(data.title).to.contain('Tis But A Scratch')
	it "status should be done", -> expect(data).to.have.property('status', 'done')
	it.skip "** DO ALL PRODUCTS NEED RETURNS? **should have a returns property", -> expect(data).to.have.property('returns')
	it "description should contain 'just a flesh wound'", -> expect(data.description).to.contain('just a flesh wound')
	it "price of '$6.00'", -> expect(data).to.have.property('price', '$6.00')

	describe 'images', ->
		it "image should contain '6dollarshirts.com'", -> expect(data.image).to.contain('6dollarshirts.com')
		it "has 1 alt-images", -> expect(data.alt_images).to.have.length(1)

	describe 'urls', ->
		it "url should contain '6dollarshirts.com'", -> expect(data.url).to.contain('6dollarshirts.com')
		it "original_url should contain '6dollarshirts.com'", -> expect(data.original_url).to.contain('6dollarshirts.com')
		it "clean_url should contain '6dollarshirts.com'", -> expect(data.clean_url).to.contain('6dollarshirts.com')

	describe 'required fields', ->
		it "should have length 4", -> expect(data.required_fields).to.have.length(4)

		describe "[0]", ->
			field = undefined
			beforeEach -> field = data.required_fields[0]
			
			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "should have name 'option 1'", -> expect(field).to.have.property('name', 'option 1')
			it "should have 2 values", -> expect(field.values).to.have.length(2)

			describe "value [0]", ->
				value = undefined
				beforeEach -> value = field.values[0];
				it "should be defined", -> expect(value).to.not.be.undefined
				it "should be instanceOf SelectOneModelOption", -> expect(value).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

				it "price '$6.00'", -> expect(value).to.have.property('price', '$6.00')
				it "image containing '6dollarshirts.com'", -> expect(value.image).to.contain('6dollarshirts.com')
				it "0 alt_images", -> expect(value.alt_images).to.have.length(0)
				it "value '137602'", -> expect(value).to.have.property('value', '137602')
				it "text 'Style: Guys Tee'", -> expect(value).to.have.property('text', 'Style: Guys Tee')
				it "empty extra_info", -> expect(value.extra_info).to.have.length(0)