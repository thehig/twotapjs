l = console.log
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
	it "should have a name property", -> expect(data).to.have.property('name')
	it "should have the name 'Property'", -> expect(data).to.have.property('name', 'Product')




	