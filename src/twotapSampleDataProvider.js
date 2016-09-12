if (typeof module != 'undefined' && module.exports) {
	require('./lib/Utilities.js');
	require('./models/ProductModel.js');
	require('./models/SelectOneModel.js');
	require('./models/SiteModel.js');
	require('./models/CartModel.js');
	require('./twotapDataProviderUtils.js');
}

(function twotapClientInit() {
	console.log('[+] Twotap Sample Data Provider 0.1.0');

	var singleProductFixture, multipleProductFixtures, multipleSiteFixtures, singleCartFixture;

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
				},
				Cart: {
					DataModel: Twotapjs.Models.CartModel,
					getCart: function() {
						// Note: Must return an array
						return [singleCartFixture];
					},
					setCart: function(cart) {
						singleCartFixture = cart;
					}
				}

			}
		),
	});
})();
if (typeof module != 'undefined' && module.exports) {
	module.exports = Twotapjs;
}