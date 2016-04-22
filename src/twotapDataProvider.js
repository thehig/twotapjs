require('./lib/Utilities.js');
require('./models/ProductModel.js');
require('./models/SelectOneModel.js');

// Note to self: This should not be here!
var singleFixture, multipleFixtures;


WinJS.Namespace.define('Twotapjs', {
	DataProvider: WinJS.Class.derive(XboxJS.Data.DataProvider,
		function dataprovider_ctor(baseUrl) {
			// You must call the base class constructor to instantiate a DataProvider.
			this._baseDataProviderConstructor();
		}, {
			Sample: {
				DataModel: Twotapjs.Models.ProductModel,
				getProduct: function() {
					// Note: Must return an array
					return [singleFixture];
				},
				setProduct: function(product){
					singleFixture = product;
				},
				getProducts: function() {
					// Note: Must return an array
					return multipleFixtures;
				},
				setProducts: function(products){
					multipleFixtures = products;
				}
			},
		}
	)
});

if (module && module.exports)
	module.exports = Twotapjs;