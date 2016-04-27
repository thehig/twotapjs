l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixture = require('./fixtures/product_three_deps.js');

describe "010. Recurse Deps", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.DataProvider()
		service.Sample.setProduct(deepcopy(fixture))
			.then service.Sample.getProduct
			.then (products)-> data = products[0]
			.then(
				() -> done()
				(err)-> done(err)
			)

	it "title should contain 'Tis But A Scratch'", -> expect(data.title).to.contain('Tis But A Scratch')

	describe 'required fields', ->
		it "should have length 4", -> expect(data.required_fields).to.have.length(4)

		describe "[0]", ->
			field = undefined
			beforeEach -> field = data.required_fields[0]
			
			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "should have name 'option 1'", -> expect(field).to.have.property('name', 'option 1')
			it "should have 2 values", -> expect(field.values).to.have.length(2)

		describe "[1]", ->
			field = undefined
			beforeEach -> field = data.required_fields[1]

			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "should have name 'option 2'", -> expect(field).to.have.property('name', 'option 2')
			it "should have 0 values", -> expect(field.values).to.have.length(0)

		describe "[2]", ->
			field = undefined
			beforeEach -> field = data.required_fields[2]

			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "should have name 'option 3'", -> expect(field).to.have.property('name', 'option 3')
			it "should have 0 values", -> expect(field.values).to.have.length(0)
			
		describe "[3]", ->
			field = undefined
			beforeEach -> field = data.required_fields[3]

			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf TextModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.TextModel)
			it "should have name 'quantity'", -> expect(field).to.have.property('name', 'quantity')

		describe.only "Option 1 first value", ->
			value = undefined
			beforeEach -> value = data.required_fields[0].values[0];
			it "should be defined", -> expect(value).to.not.be.undefined
			it "should be instanceOf SelectOneModelOption", -> expect(value).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

			it "text 'Style: Guys Tee'", -> expect(value).to.have.property('text', 'Style: Guys Tee')
			it "price '$6.00'", -> expect(value).to.have.property('price', '$6.00')
			it "image containing '6dollarshirts.com'", -> expect(value.image).to.contain('6dollarshirts.com')
			it "0 alt_images", -> expect(value.alt_images).to.have.length(0)
			it "value '137602'", -> expect(value).to.have.property('value', '137602')
			it "empty extra_info", -> expect(value.extra_info).to.have.length(0)

			it "should have a dep property", -> expect(value).to.have.property('dep')
			it "should be an array with 1 value", -> expect(value.dep).to.have.length(1)

			describe "Option 2 SelectModel", ->
				dep = undefined
				beforeEach -> dep = value.dep[0]

				it "should be defined", -> expect(dep).to.not.be.undefined
				it "should be instanceOf SelectOneModel", -> expect(dep).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
				it "should have name 'option 2'", -> expect(dep).to.have.property('name', 'option 2')
				it "should have 5 values", -> expect(dep.values).to.have.length(5)
			
				describe "first value (Color)", ->
					depvalue = undefined
					beforeEach -> depvalue = dep.values[0]

					it "should be defined", -> expect(depvalue).to.not.be.undefined
					it "should be instanceOf SelectOneModelOption", -> expect(depvalue).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

					it "text 'Color: White'", -> expect(depvalue).to.have.property('text', 'Color: White')
					it "price '$6.00'", -> expect(depvalue).to.have.property('price', '$6.00')
					it "image containing '6dollarshirts.com'", -> expect(depvalue.image).to.contain('6dollarshirts.com')
					it "0 alt_images", -> expect(depvalue.alt_images).to.have.length(0)
					it "value '137616'", -> expect(depvalue).to.have.property('value', '137616')
					it "empty extra_info", -> expect(depvalue.extra_info).to.have.length(0)

					describe "Option 3 SelectModel", ->
						optvalue = undefined
						beforeEach -> optvalue = depvalue.dep[0]
		
						it "should be defined", -> expect(optvalue).to.not.be.undefined
						it "should be instanceOf SelectOneModel", -> expect(optvalue).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
						it "should have name 'option 3'", -> expect(optvalue).to.have.property('name', 'option 3')
						it "should have 6 values", -> expect(optvalue.values).to.have.length(6)

						describe "first value (Size)", ->
							opt3value = undefined
							beforeEach -> opt3value = optvalue.values[0]

							it "should be defined", -> expect(opt3value).to.not.be.undefined
							it "should be instanceOf SelectOneModelOption", -> expect(opt3value).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

							it "text 'Size: Small'", -> expect(opt3value).to.have.property('text', 'Size: Small')
							it "price '$6.00'", -> expect(opt3value).to.have.property('price', '$6.00')
							it "image containing '6dollarshirts.com'", -> expect(opt3value.image).to.contain('6dollarshirts.com')
							it "0 alt_images", -> expect(opt3value.alt_images).to.have.length(0)
							it "value '137627'", -> expect(opt3value).to.have.property('value', '137627')
							it "empty extra_info", -> expect(opt3value.extra_info).to.have.length(0)
