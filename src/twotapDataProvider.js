require('./lib/Utilities.js');
require('./models/ProductModel.js');

// Note to self: This should not be here!
var productOneFixture = require('./fixtures/product_one.js');


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
					return [productOneFixture];
				}
			},
		}
	)
});

if (module && module.exports)
	module.exports = Twotapjs;