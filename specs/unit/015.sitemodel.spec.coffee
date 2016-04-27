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
			.then (sites)-> data = sites[0]
			.then(
				() -> done()
				(err)-> done(err)
			)

	
	it "should have returned data", -> expect(data).to.not.be.undefined
	it "should be instance of SiteModel", -> expect(data).to.be.instanceOf(Twotapjs.Models.SiteModel)
