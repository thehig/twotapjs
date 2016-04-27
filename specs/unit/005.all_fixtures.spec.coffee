l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixtures = require('./fixtures/list.js');

describe "005. All Fixtures", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.SampleDataProvider()
		service.Product.setProducts(deepcopy(fixtures.all_products_array))
			.then service.Product.getProducts
			.then (products)-> data = products
			.then(
				() -> done()
				(err)-> done(err)
			)

	it "should have the same number of items after DataProvider (" + fixtures.all_products_array.length + ")", ->
		expect(data.length).to.equal(fixtures.all_products_array.length)