require('./lib/Utilities.js');
require('./models/ProductModel.js');

WinJS.Namespace.define('Twotapjs', {
	DataProvider: WinJS.Class.derive(XboxJS.Data.DataProvider,
		function dataprovider_ctor(baseUrl) {
			// You must call the base class constructor to instantiate a DataProvider.
			this._baseDataProviderConstructor();
		}, {
			Sample: {
				DataModel: Twotapjs.Models.ProductModel,
				getProduct: function() {
				}
			},
		}
	)
});

if (module && module.exports)
	module.exports = Twotapjs;