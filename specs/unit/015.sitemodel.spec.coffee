l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
jf = require('jsonfile')
fixture = undefined

describe "015. Sites Fixture", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		fixture = jf.readFileSync('./specs/unit/fixtures/hugecart.fixture.json')
		service = new dp.SampleDataProvider()
		service.Site.setSites(fixture)
			.then service.Site.getSites
			.then (sites)-> data = sites
			.then(
				() -> done()
				(err)-> done(err)
			)

	
	it "should have returned data", -> expect(data).to.not.be.undefined
	it "should have 23 items", -> expect(data).to.have.length(23)
	
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

		it "currency_format of '$AMOUNT'", -> expect(site).to.have.property('currency_format', '$AMOUNT')
		it "coupon_support of 'true'", -> expect(site).to.have.property('coupon_support', true)
		it "gift_card_support of 'false'", -> expect(site).to.have.property('gift_card_support', false)
		it "non-empty returns", -> expect(site.returns).to.have.length.above(0)

		describe "checkout_support", ->
			it "at least one", -> expect(site.checkout_support).to.have.length.above(0)
			it "[0] of 'noauthCheckout'", -> expect(site.checkout_support[0]).to.equal('noauthCheckout')

		describe "shipping_countries_support", ->
			it "at least one", -> expect(site.shipping_countries_support).to.have.length.above(0)
			it "[0] of 'United States of America'", -> expect(site.shipping_countries_support[0]).to.equal('United States of America')

		describe "billing_countries_support", ->
			it "at least one", -> expect(site.billing_countries_support).to.have.length.above(0)
			it "[0] of 'United States of America'", -> expect(site.billing_countries_support[0]).to.equal('United States of America')

	describe "Site[6]", ->
		site = undefined
		beforeEach -> site = data[6]

		it "name of 'Lego'", -> expect(site).to.have.property('name', 'Lego')

		describe "failed to add to cart", ->
			it "length above 0", -> expect(site.failed_to_add_to_cart).to.have.length.above(0)

			describe "[0]", ->
				failed = undefined
				beforeEach -> failed = site.failed_to_add_to_cart[0]
				it "title of 'Fire Starter Set'", -> expect(failed).to.have.property('title', 'Fire Starter Set')
				it "price of undefined", -> expect(failed).to.have.property('price', undefined)
				
				it "url containing 'shop.lego.com'", -> expect(failed.url).to.contain('shop.lego.com')
				it "original_url containing 'shop.lego.com'", -> expect(failed.original_url).to.contain('shop.lego.com')
				it "clean_url containing 'shop.lego.com'", -> expect(failed.clean_url).to.contain('shop.lego.com')
				it "status of 'failed'", -> expect(failed).to.have.property('status', 'failed')
				it "description length above 0", -> expect(failed.description).to.have.length.above(0)
				it "image containing 'cache.lego.com'", -> expect(failed.image).to.contain('cache.lego.com')

				it "1 required field named 'quantity'", -> 
					expect(failed.required_fields).to.have.length(1)
					expect(failed.required_fields[0]).to.have.property('name', 'quantity')