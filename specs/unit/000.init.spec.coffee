l = console.log
require('../src/twotapDataProvider.js')
expect = require('chai').expect

describe "Initially", ->
	it "Should have a Twotapjs namespace", -> expect(Twotapjs).to.exist
