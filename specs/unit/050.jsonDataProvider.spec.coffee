l = console.log
j = require('circular-json').stringify
p = (item) -> l(j(item, null, 4))

dp = require('../../src/twotapJSONDataProvider.js')
expect = require('chai').expect

fixture = require('./fixtures/573defe0a5af06fc49ddd0b8.json').body

models = 0
options = 0

checkIsSelectOneOption = (option) ->
	options++
	expect(option).to.be.instanceOf(Twotapjs.Models.SelectOneModelOption)
	if(option.dep) 
		checkIsSelectOneModel(dep) for dep in option.dep

checkIsSelectOneModel = (field)->
	models++
	expect(field).to.be.instanceOf(Twotapjs.Models.SelectOneModel)
	checkIsSelectOneOption(option) for option in field.values

checkProductDataModels = (product) ->
	models = 0
	options = 0
	checkIsSelectOneModel(field) for field in product.required_fields

describe "050.JSONDataProvider", ->

	service = new dp.JSONDataProvider()
	cart = undefined

	describe ".Cart.getCart", ->
		beforeEach ->
			service.Cart.getCart(fixture).then (result)-> cart = result[0]
		afterEach ->
			cart = undefined
			
		it "returns a CartDataModel", ->
			expect(cart).to.be.instanceOf(Twotapjs.Models.CartModel)
		it "contains 23 SiteDataModel(s)", ->
			expect(cart.sites).to.have.length(23)
			expect(cart.sites[0]).to.be.instanceof(Twotapjs.Models.SiteModel)
		it "site 14 contains 1 ProductDataModel(s)", ->
			expect(cart.sites[14].add_to_cart).to.have.length(1)
			expect(cart.sites[14].add_to_cart[0]).to.be.instanceof(Twotapjs.Models.ProductModel)

	describe ".GetCart", ->
		product = undefined
		field = undefined

		beforeEach ->
			service.GetCart(fixture).then (result)-> 
				cart = result
				product = result.sites[14].add_to_cart[0]
				field = product.required_fields[0]
		afterEach ->
			cart = undefined
			product = undefined
		
		describe "030.dropdown", ->
			it "Product has 4 required fields (SelectOneModel)", ->
				expect(product.required_fields).to.have.length(4)
				expect(product.required_fields[0]).to.be.instanceof(Twotapjs.Models.SelectOneModel)
			it "Option[0].values[0] has 1 dependant (SelectOneModel)", ->
				expect(product.required_fields[0].values[0].dep).to.have.length(1)
				expect(product.required_fields[0].values[0]).to.be.instanceof(Twotapjs.Models.SelectOneModelOption)
				expect(product.required_fields[0].values[0].dep[0]).to.be.instanceof(Twotapjs.Models.SelectOneModel)
			it "Product has 26 SelectOneModel(s) and 182 SelectOneModelOption(s)", ->
				checkProductDataModels(product)
				expect(models).to.equal(26)
				expect(options).to.equal(182)
			
		describe "035.references", ->
			it "site has cart", -> expect(cart.sites[0]).to.have.property('_cart')
			it "product has cart, site", -> 
				expect(product).to.have.property('_site')
				expect(product).to.have.property('_cart')
			it "SelectOneModel has product, cart, site", -> 
				expect(product.required_fields[0]).to.have.property('_product')
				expect(product.required_fields[0]).to.have.property('_cart')
				expect(product.required_fields[0]).to.have.property('_site')
			it "SelectOneModelOption has ParentModel, ParentOption", -> 
				expect(product.required_fields[0].values[0]).to.have.property('parentModel')
				expect(product.required_fields[0].values[0].dep[0].values[0]).to.have.property('parentOption')
		
		describe "040.observable", ->
			it "has observableValues collection", -> expect(product.required_fields[0]).to.have.property('observableValues')			
			it "has 2 observableValues for option 1", -> expect(product.required_fields[0].observableValues).to.have.length(2)
			it "has 0 observableValues for option 2", -> expect(product.required_fields[1].observableValues).to.have.length(0)
			it "has 0 observableValues for option 3", -> expect(product.required_fields[2].observableValues).to.have.length(0)

			describe "clicking on option 1 - Girls", ->
				beforeEach -> service.clickOption(product.required_fields[0].observableValues[1])
				it "option 1 has selected property", -> expect(field).to.have.property('selected')
				it "has 0 observableValues for option 3", -> expect(product.required_fields[2].observableValues).to.have.length(0)
				somoText = (text, i) -> it "[" + i + "] text '" + text + "'", -> expect(product.required_fields[1].observableValues[i]).to.have.property('text', text)
				
				describe "option 2", ->
					somoText(item, i) for item, i in ["Color: Snow", "Color: Sky Blue", "Color: Gray Granite", "Color: Soft Pink", "Color: Light Lemon"]

				describe "clicking on option 1 - Guys", ->
					beforeEach -> service.clickOption(product.required_fields[0].observableValues[0])
					somoText(item, i) for item, i in ["Color: White", "Color: Heather Gray", "Color: Light Blue", "Color: Charcoal", "Color: Sand"]

			describe "clicking on option 2 - Sky Blue", ->
				beforeEach -> 
					service.clickOption(product.required_fields[0].observableValues[1])
					service.clickOption(product.required_fields[1].observableValues[1])			

				it "option 1 has selected.text 'Style: Girls Tee'", -> expect(product.required_fields[0].selected).to.have.property('text', 'Style: Girls Tee')
				it "option 2 has selected.text 'Color: Sky Blue'", -> expect(product.required_fields[1].selected).to.have.property('text', 'Color: Sky Blue')
				
			describe "clicking on option 3 - Medium", ->
				beforeEach -> 
					service.clickOption(product.required_fields[0].observableValues[1])
					service.clickOption(product.required_fields[1].observableValues[1])			
					service.clickOption(product.required_fields[2].observableValues[1])			

				it "option 1 has selected.text 'Style: Girls Tee'", -> expect(product.required_fields[0].selected).to.have.property('text', 'Style: Girls Tee')
				it "option 2 has selected.text 'Color: Sky Blue'", -> expect(product.required_fields[1].selected).to.have.property('text', 'Color: Sky Blue')
				it "option 3 has selected.text 'Size: Medium'", -> expect(product.required_fields[2].selected).to.have.property('text', 'Size: Medium')


		describe "045.quantity", ->
			beforeEach -> field = product.required_fields[3]
			it "quantity is autofilled 1 - 10", -> expect(field.values).to.have.length(10)
			describe "click", ->
				beforeEach -> service.clickOption(field.observableValues[1])
				it "has selected property", -> expect(field).to.have.property('selected')
				it "has selected.text '2'", -> expect(field.selected).to.have.property('text', 2)


