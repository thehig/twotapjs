if (typeof module != 'undefined' && module.exports) {
	require('./lib/Utilities.js');
	require('./models/ProductModel.js');
	require('./models/SelectOneModel.js');
	require('./models/SiteModel.js');
	require('./models/CartModel.js');
}

(function twotapClientInit() {
	console.log('[+] Twotap Data Provider 0.0.0');

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
						return Twotapjs.Utilities._requestWrapper(requestUrl);
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
						var statuserr = new Error("Invalid http status");
						statuserr.httpResult = httpResult;
						throw statuserr;
					}
					var parsedresponse;
					try {
						parsedresponse = JSON.parse(httpResult.responseText);
					} catch (excp) {
						var parseerr = new Error("Unable to parse responseText");
						parseerr.httpResult = httpResult;
						throw parseerr;
					}

					if (!parsedresponse.body) {
						var bodyerr = new Error("Body not found on parsed repsonse");
						bodyerr.httpResult = httpResult;
						throw bodyerr;
					}

					return [parsedresponse.body];
				});
		},
		processRequiredFields: function(product){
			var verbose = false;
			// Bindings will contain the list of populated datas
			product.bindings = [];

			// Iterate through the current products required fields
			for(var i = 0; i < product.required_fields.length; i++){
				var selectOneModel = product.required_fields[i];
				// If this required_field has values, push it into the bindings list and we're done
				if(selectOneModel.values && selectOneModel.values.length > 0){
					product.bindings.push(selectOneModel);
					continue;					
				} else if (selectOneModel.name === 'quantity') {
					// If this required_field has name 'quantity', we don't care about its values, so we push it into the bindings list and we're done
					product.bindings.push(selectOneModel);
					continue;
				}

				// At this point, we know we do not have any values, and the name is not quantity
				if(verbose) console.log("No values found for " + selectOneModel.name);
				var deps = [];

				// Go through all the previously processed binding lists
				for(var j = 0; j < product.bindings.length; j++){
					var previousModel = product.bindings[j];
					if(verbose) console.log("\tSearching " + previousModel.name);

					// Iterate through the values of the previous binding item
					for(var k = 0; k < previousModel.values.length; k++){
						var value = previousModel.values[k];
						if(verbose) console.log("\t\tSearching " + value.text);

						// If there are no deps, it's definitely not this one but we're not done searching so we want to continue the for loop
						if(!value.dep) continue;

						// Iterate through the deps on the value
						for(var m = 0; m < value.dep.length; m++){
							var dep = value.dep[m];
							// If this dep has the same name as the selectOneModel we were looking for, we have successfully found one instance
							if(dep.name === selectOneModel.name){
								deps.push(dep);
							}
						}						
					}
				}

				// We have now iterated through all the previous binding lists and have pulled out all the instances of the selectOneModel
				if(verbose) console.log("\tOccurences of " + selectOneModel.name + " : " + deps.length);

				// These objects however, are the SelectOneModels and not the SelectOneModelOptions, so we join them all together
				var allDeps = deps.reduce(function(previous, current){
					return previous.concat(current.values);
				}, []);

				if(verbose) console.log("\tAll Deps Length " + allDeps.length);

				// Since we can have many copies of the same name (eg: Size: Medium), we only want to display the unique names to the user in the list
				var uniqueDeps = Twotapjs.Utilities.uniqueBy(allDeps, function(x){return x.text;});
				if(verbose) console.log("\tUnique Deps Length " + uniqueDeps.length);

				// Since the selectOneModel we're editing here is a reference to the SelectOneModel DataModel, and is passed by ref, inserting values here actually modifies the SelectOneModel in required_fields as well
				selectOneModel.values = uniqueDeps;
				product.bindings.push(selectOneModel);
			}
		},
		uniqueBy: function(arr, fn) {
			// Create a map object to store the unique keys
			var unique = {};
			// Create an array to store the unique objects
			var distinct = [];
			// Iterate through the array
			arr.forEach(function(x) {
				// Execute the provided function against the current item (x)
				var key = fn(x);
				// If this key is not already in the map
				if (!unique[key]) {
					// Push the object into the unique items list
					distinct.push(x);
					// Add the key to the map with the value 'true'
					unique[key] = true;
				}
			});
			// Return the list of unique objects
			return distinct;
		}
	});

})();
if (typeof module != 'undefined' && module.exports) {
	module.exports = Twotapjs;
}