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



WinJS.Namespace.define('Twotapjs.Utilities', {
	unrecognised: function(source, target, errormessage, whitelist){
		whitelist = whitelist || [];

		var originalKeys = Object.keys(source);
		var recognisedKeys = Object.keys(target);
		
		// Add a whitelist of things we don't really care about
		recognisedKeys = recognisedKeys.concat(whitelist);

		// Give us the 
		var unrecognisedKeys = originalKeys.filter(function(n) {
		    return recognisedKeys.indexOf(n) == -1;
		});

		if(unrecognisedKeys.length !== 0) throw new Error(errormessage + unrecognisedKeys);
		return unrecognisedKeys;
	}
});

if (module && module.exports)
	module.exports = Twotapjs;