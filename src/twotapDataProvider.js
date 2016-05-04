require('./lib/Utilities.js');
require('./models/ProductModel.js');
require('./models/SelectOneModel.js');
require('./models/SiteModel.js');
require('./models/CartModel.js');
// Note to self: This should not be here!
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
	CallBackCatcherDataProvider: WinJS.Class.derive(XboxJS.Data.DataProvider,
		function dataprovider_ctor(baseUrl) {
			// You must call the base class constructor to instantiate a DataProvider.
			this._baseDataProviderConstructor();
			this.Cart.getCart.items = null;
		}, {
			Cart: {
				DataModel: Twotapjs.Models.CartModel,

				getCart: function(cartID) {
					var tempID = cartID;
					var baseUrl = "http://callbackcatcher.meteorapp.com/search/body.cart_id=";
					var requestUrl = baseUrl + (tempID || "");
					return Twotapjs.Utilities._requestWrapper(requestUrl).then(function(results){
						return results;
					});
				}
			}

		}
	)
});



WinJS.Namespace.define('Twotapjs.Utilities', {
	_defaultTimeout: 30000,

	unrecognised: function(source, target, errormessage, whitelist) {
		whitelist = whitelist || [];

		var originalKeys = Object.keys(source);
		var recognisedKeys = Object.keys(target);

		// Add a whitelist of things we don't really care about
		recognisedKeys = recognisedKeys.concat(whitelist);

		// Give us the 
		var unrecognisedKeys = originalKeys.filter(function(n) {
			return recognisedKeys.indexOf(n) == -1;
		});

		if (unrecognisedKeys.length !== 0) throw new Error(errormessage + unrecognisedKeys);
		return unrecognisedKeys;
	},
	_requestWrapper: function(requestUrl, timeout) {
		return WinJS.Promise.timeout(timeout ? timeout : Twotapjs.Utilities._defaultTimeout,
			WinJS.xhr({
				url: requestUrl,
				responseType: "json",
				type: "GET"
			})
		).then(
			function httpSuccess(httpResult) {
				
				if (httpResult.status != 200) {
					var err = new Error("Invalid http status");
					err.httpResult = httpResult;
					throw err;
				}

				try{
					var parsedresponse = JSON.parse(httpResult.responseText);
				}
				catch(excp){
					var err = new Error("Unable to parse responseText");
					err.httpResult = httpResult;
					throw err;
				}

				if (!parsedresponse.body) {
					var err = new Error("Body not found on parsed repsonse");
					err.httpResult = httpResult;
					throw err;
				}

				return [parsedresponse.body];
			});
	}
});

if (module && module.exports)
	module.exports = Twotapjs;