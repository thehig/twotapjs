l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapSampleDataProvider.js')
expect = require('chai').expect
jf = require('jsonfile')
fixture = undefined

describe "010. Recurse Deps", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		fixture = jf.readFileSync('./specs/unit/fixtures/product_three_deps.json')

		service = new dp.SampleDataProvider()
		service.Product.setProduct(fixture)
			.then service.Product.getProduct
			.then (products)-> data = products[0]
			.then(
				() -> done()
				(err)-> done(err)
			)

	it "title should contain 'Tis But A Scratch'", -> expect(data.title).to.contain('Tis But A Scratch')
	it "required_fields length 4", -> expect(data.required_fields).to.have.length(4)

	describe "Empty required fields", ->
		describe "[1]", ->
			field = undefined
			beforeEach -> field = data.required_fields[1]

			it "defined", -> expect(field).to.not.be.undefined
			it "instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "name 'option 2'", -> expect(field).to.have.property('name', 'option 2')
			it "0 values", -> expect(field.values).to.have.length(0)

		describe "[2]", ->
			field = undefined
			beforeEach -> field = data.required_fields[2]

			it "defined", -> expect(field).to.not.be.undefined
			it "instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "name 'option 3'", -> expect(field).to.have.property('name', 'option 3')
			it "0 values", -> expect(field.values).to.have.length(0)
			
		describe "[3]", ->
			field = undefined
			beforeEach -> field = data.required_fields[3]

			it "defined", -> expect(field).to.not.be.undefined
			it "instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "name 'quantity'", -> expect(field).to.have.property('name', 'quantity')

	describe "Option 1: Style", ->
		field = undefined
		beforeEach -> field = data.required_fields[0]
		
		it "defined", -> expect(field).to.not.be.undefined
		it "instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
		it "name 'option 1'", -> expect(field).to.have.property('name', 'option 1')
		it "2 values", -> expect(field.values).to.have.length(2)

		describe "first value", ->
			value = undefined
			beforeEach -> value = field.values[0];
			it "defined", -> expect(value).to.not.be.undefined
			it "instanceOf SelectOneModelOption", -> expect(value).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

			it "text 'Style: Guys Tee'", -> expect(value).to.have.property('text', 'Style: Guys Tee')
			it "price '$6.00'", -> expect(value).to.have.property('price', '$6.00')
			it "image containing '6dollarshirts.com'", -> expect(value.image).to.contain('6dollarshirts.com')
			it "0 alt_images", -> expect(value.alt_images).to.have.length(0)
			it "value '137602'", -> expect(value).to.have.property('value', '137602')
			it "empty extra_info", -> expect(value.extra_info).to.have.length(0)

			it "a dep property", -> expect(value).to.have.property('dep')
			it "an array with 1 value", -> expect(value.dep).to.have.length(1)

	describe "Option 2: Color", ->
		value = undefined
		beforeEach -> value = data.required_fields[0].values[0].dep[0];

		it "defined", -> expect(value).to.not.be.undefined
		it "instanceOf SelectOneModel", -> expect(value).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
		it "name 'option 2'", -> expect(value).to.have.property('name', 'option 2')
		it "5 values", -> expect(value.values).to.have.length(5)
	
		describe "first value", ->
			depvalue = undefined
			beforeEach -> depvalue = value.values[0]

			it "defined", -> expect(depvalue).to.not.be.undefined
			it "instanceOf SelectOneModelOption", -> expect(depvalue).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

			it "text 'Color: White'", -> expect(depvalue).to.have.property('text', 'Color: White')
			it "price '$6.00'", -> expect(depvalue).to.have.property('price', '$6.00')
			it "image containing '6dollarshirts.com'", -> expect(depvalue.image).to.contain('6dollarshirts.com')
			it "0 alt_images", -> expect(depvalue.alt_images).to.have.length(0)
			it "value '137616'", -> expect(depvalue).to.have.property('value', '137616')
			it "empty extra_info", -> expect(depvalue.extra_info).to.have.length(0)

	describe "Option 3: Size", ->
		value = undefined
		beforeEach -> value = data.required_fields[0].values[0].dep[0].values[0].dep[0]

		it "defined", -> expect(value).to.not.be.undefined
		it "instanceOf SelectOneModel", -> expect(value).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
		it "name 'option 3'", -> expect(value).to.have.property('name', 'option 3')
		it "6 values", -> expect(value.values).to.have.length(6)

		describe "first value", ->
			depvalue = undefined
			beforeEach -> depvalue = value.values[0]

			it "defined", -> expect(depvalue).to.not.be.undefined
			it "instanceOf SelectOneModelOption", -> expect(depvalue).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

			it "text 'Size: Small'", -> expect(depvalue).to.have.property('text', 'Size: Small')
			it "price '$6.00'", -> expect(depvalue).to.have.property('price', '$6.00')
			it "image containing '6dollarshirts.com'", -> expect(depvalue.image).to.contain('6dollarshirts.com')
			it "0 alt_images", -> expect(depvalue.alt_images).to.have.length(0)
			it "value '137627'", -> expect(depvalue).to.have.property('value', '137627')
			it "empty extra_info", -> expect(depvalue.extra_info).to.have.length(0)
