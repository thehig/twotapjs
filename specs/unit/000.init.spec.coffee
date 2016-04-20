l = console.log
dp = require('../src/twotapDataProvider.js')
expect = require('chai').expect

describe "Initially", ->
	it "Should have a Twotapjs namespace with DataProvider property", -> 
		expect(Twotapjs).to.exist
		expect(Twotapjs).to.not.be.null
		expect(Twotapjs).to.have.property('DataProvider')
	it "Should have a Twotapjs object with DataProvider property", -> 
		expect(dp).to.exist
		expect(dp).to.not.be.null
		expect(dp).to.have.property('DataProvider')
