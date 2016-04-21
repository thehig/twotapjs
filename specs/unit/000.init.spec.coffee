l = console.log
j = JSON.stringify

dp = require('../src/twotapDataProvider.js')
expect = require('chai').expect

describe "Initially Twotapjs", ->
	it "Namespace should exist with DataProvider property", -> 
		expect(Twotapjs).to.exist
		expect(Twotapjs).to.not.be.null
		expect(Twotapjs).to.have.property('DataProvider')
	it "module should exist with DataProvider property", -> 
		expect(dp).to.exist
		expect(dp).to.not.be.null
		expect(dp).to.have.property('DataProvider')

	it ".Models Namespace should exist", -> expect(Twotapjs.Models).to.exist
	it ".Models.ProductModel should exist", -> expect(Twotapjs.Models.ProductModel).to.exist

describe "DataProvider service", ->
	service = undefined
	beforeEach ->
		service = new dp.DataProvider()

	it "should have initialized", -> expect(service).to.not.be.undefined
	it "should have a Sample property", -> expect(service).to.have.property('Sample')
	it "with a getProduct property", -> expect(service.Sample).to.have.property('getProduct')

describe "Sample.getProduct", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.DataProvider()
		service.Sample.getProduct()
			.then (product)->
				data = product[0]
				done()

	it "should have returned data", -> expect(data).to.not.be.undefined
	it "should be instance of ProductModel", -> expect(data).to.be.instanceOf(Twotapjs.Models.ProductModel)
	it "should have a title property", -> expect(data).to.have.property('title')
	it "title should contain 'Blue & Red Gnome'", -> expect(data.title).to.contain('Blue & Red Gnome')
	it "status should be done", -> expect(data).to.have.property('status', 'done')

	describe 'images', ->
		it "image should contain 'shopify.com'", -> expect(data.image).to.contain('shopify.com')
		it "has 3 alt-images", -> expect(data.alt_images).to.have.length(3)

	describe 'urls', ->
		it "url should contain 'afreakaclothing.com'", -> expect(data.url).to.contain('afreakaclothing.com')
		it "original_url should contain 'afreakaclothing.com'", -> expect(data.original_url).to.contain('afreakaclothing.com')
		it "clean_url should contain 'afreakaclothing.com'", -> expect(data.clean_url).to.contain('afreakaclothing.com')

	describe 'required fields', ->
		it "should have length 2", -> expect(data.required_fields).to.have.length(2)

		describe "[0]", ->
			field = undefined
			beforeEach -> field = data.required_fields[0]
			
			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "should have name 'quantity'", -> expect(field).to.have.property('name', 'quantity')

		describe "[1]", ->
			field = undefined
			beforeEach -> field = data.required_fields[1]
			
			it "should be defined", -> expect(field).to.not.be.undefined
			it "should be instanceOf SelectOneModel", -> expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
			it "should have name 'size'", -> expect(field).to.have.property('name', 'size')
			it "should have 9 size values", -> expect(field.values).to.have.length(9)

			describe "value [0]", ->
				value = undefined
				beforeEach -> value = field.values[0];
				it "should be defined", -> expect(value).to.not.be.undefined
				it "should be instanceOf SelectOneModelOption", -> expect(value).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)

				it "price '$450.00'", -> expect(value).to.have.property('price', '$450.00')
				it "image containing 'shopify.com'", -> expect(value.image).to.contain('shopify.com')
				it "3 alt_images", -> expect(value.alt_images).to.have.length(3)
				it "value '5-6 years'", -> expect(value).to.have.property('value', '5-6 years')
				it "text '5-6 years'", -> expect(value).to.have.property('text', '5-6 years')
				it "empty extra_info", -> expect(value.extra_info).to.have.length(0)




			# expect(data.required_fields[1]).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
		# it "should have [0] name 'size'", -> expect(data.required_fields[0]).to.have.property('name', 'size')
		# it "should have [1] name 'quantity'", -> expect(data.required_fields[1]).to.have.property('name', 'quantity')




	