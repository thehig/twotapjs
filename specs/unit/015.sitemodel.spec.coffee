l = console.log
j = JSON.stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapDataProvider.js')
expect = require('chai').expect
deepcopy = require('deepcopy')
fixture = require('./fixtures/hugecart.fixture.js');

describe "001. Product Two Fixture", ->
	data = undefined
	service = undefined
	beforeEach (done)->
		service = new dp.DataProvider()
		service.Sample.setSite(deepcopy(fixture))
			.then service.Sample.getSite
			.then (sites)-> data = sites[0]
			.then(
				() -> done()
				(err)-> done(err)
			)

	