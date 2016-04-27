require('./lib/Utilities.js');
require('./models/ProductModel.js');
require('./models/SelectOneModel.js');
require('./models/SiteModel.js');

// Note to self: This should not be here!
var singleProductFixture, multipleProductFixtures, multipleSiteFixtures;


WinJS.Namespace.define('Twotapjs', {
	SampleDataProvider: WinJS.Class.derive(XboxJS.Data.DataProvider,
		function dataprovider_ctor(baseUrl) {
			// You must call the base class constructor to instantiate a DataProvider.
			this._baseDataProviderConstructor();
		}, {
			Product: {
				DataModel: Twotapjs.Models.ProductModel,
				getProduct: function() {
					// Note: Must return an array
					return [singleProductFixture];
				},
				setProduct: function(product) {
					singleProductFixture = product;
				},
				getProducts: function() {
					// Note: Must return an array
					return multipleProductFixtures;
				},
				setProducts: function(products) {
					multipleProductFixtures = products;
				}
			},
			Site: {
				DataModel: Twotapjs.Models.SiteModel,
				getSites: function() {
					// Note: Must return an array
					return Object.keys(multipleSiteFixtures.sites).map(function(key) {
						return multipleSiteFixtures.sites[key];
					});
				},
				setSites: function(sites) {
					multipleSiteFixtures = sites;
				}
			}

		}
	)
});

if (module && module.exports)
	module.exports = Twotapjs;