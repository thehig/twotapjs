dp = require('../../src/twotapJSONDataProvider.js')
fixture = require('./fixtures/573defe0a5af06fc49ddd0b8.json').body

# Implement some useful shorthand utils for testing
console.log('[*] Adding testing shorthand functions')
l = console.log
j = require('circular-json').stringify
p = (item) -> l(j(item, null, 4))
k = (item) -> l(Object.keys(item))

# Test Harness
chai = require('chai')
expect = chai.expect
chaiAsPromised = require('chai-as-promised')
chai.use(chaiAsPromised)

describe.only "055.Purchase", ->

	service = undefined
	cart = undefined

	beforeEach ->
		service = new dp.JSONDataProvider()
		service.Cart.getCart(fixture).then (result)-> cart = result[0]
			
	describe "Purchase", ->
		it "exists", -> expect(service).to.have.property('Purchase')

		describe "throws an error if", ->			
			it 'No parameter', -> expect(service.Purchase()).to.be.rejectedWith("Missing cart parameter")
			it 'Invalid parameter', -> expect(service.Purchase({})).to.be.rejectedWith("Invalid cart parameter")
			# it 'No CartId', -> expect(service.pollCart(wishlist)).to.be.rejectedWith("No cartId provided")
		
		###
		it "Cart has 1 site", -> expect().to.have.length(1)
		it "Site has 2 items", -> expect().to.have.length(2)
		describe "AddToCart[0] Selections", ->
			it "Has 3 options", -> expect().to.have.length(3)
			it "Click on Option 1 Value N", ->
			it "Click on Option 2 Value N", ->
			it "Click on Option 3 Value N", ->
		describe "AddToCart[1] Selections", ->
			it "Has 3 options", -> expect().to.have.length(3)
			it "Click on Option 1 Value N", ->
			it "Click on Option 2 Value N", ->
			it "Click on Option 3 Value N", ->
		
		###