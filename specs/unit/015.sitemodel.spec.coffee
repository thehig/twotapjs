l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixture = require('./fixtures/hugecart.fixture.js');

describe "015. Sites Fixture", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.SampleDataProvider()
		service.Site.setSites(deepcopy(fixture))
			.then service.Site.getSites
			.then (sites)-> data = sites
			.then(
				() -> done()
				(err)-> done(err)
			)

	
	it "should have returned data", -> expect(data).to.not.be.undefined
	
	describe "Site[0]", ->
		site = undefined
		beforeEach -> site = data[0]
		it "should be instance of SiteModel", -> expect(site).to.be.instanceOf(Twotapjs.Models.SiteModel)

		describe "info", ->
			it "should have a name 'aFREAKa Clothing'", -> expect(site).to.have.property("name", "aFREAKa Clothing")
			it "should have a logo containing '570ce00481fe1d62245836fc'", -> expect(site.logo).to.contain("570ce00481fe1d62245836fc")
			it "should have a url 'afreakaclothing.com'", -> expect(site).to.have.property("url", "afreakaclothing.com")
		
		describe "shipping options", ->
			it "should have at least 1 shipping option", -> expect(site.shipping_options).to.have.length.above(0)
			describe "option [0]", ->
				it "name is 'fastest'", -> expect(site.shipping_options[0]).to.have.property("name", "fastest")
				it "value is '3 days'", -> expect(site.shipping_options[0]).to.have.property("value", "3 days")
			describe "option [1]", ->
				it "name is 'cheapest'", -> expect(site.shipping_options[1]).to.have.property("name", "cheapest")
				it "value is '1 day'", -> expect(site.shipping_options[1]).to.have.property("value", "1 day")

		describe "add to cart", ->
			it "should be an array", -> expect(site.add_to_cart).to.be.instanceOf(Array)
			it "should have length above 0", -> expect(site.add_to_cart).to.have.length.above(0)
			it "should have length 1", -> expect(site.add_to_cart).to.have.length(1)

			describe "[0]", ->
				product = undefined
				beforeEach -> product = site.add_to_cart[0]

				it "should be instance of ProductModel", -> expect(product).to.be.instanceOf(Twotapjs.Models.ProductModel)

