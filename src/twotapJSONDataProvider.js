if (typeof module != 'undefined' && module.exports) {
	require('./lib/Utilities.js');
	require('./models/ProductModel.js');
	require('./models/SelectOneModel.js');
	require('./models/SiteModel.js');
	require('./models/CartModel.js');
	require('./models/PurchaseModel.js');
	require('./twotapDataProviderUtils.js');
}

(function twotapClientInit() {
	console.log('[+] Twotap JSON Data Provider 0.1.2');

	var singleProductFixture, multipleProductFixtures, multipleSiteFixtures, singleCartFixture;


	WinJS.Namespace.define('Twotapjs', {
		JSONDataProvider: WinJS.Class.derive(XboxJS.Data.DataProvider,
			function dataprovider_ctor(baseUrl) {
				// You must call the base class constructor to instantiate a DataProvider.
				this._baseDataProviderConstructor();
				this.Cart.getCart.items = null;
			}, {
				Cart: {
					DataModel: Twotapjs.Models.CartModel,

					getCart: function(cartJson) {
						return [cartJson];
					}
				},
				GetCart: function(cartJson){
					var self = this;
					return this.Cart.getCart(cartJson).then(function(cartArray){
						// Take the processed cart out of the array
						var cart = cartArray[0];
						var promises = [];

						// Iterate through the sites
						for(var i = 0; i < cart.sites.length; i++){
							var site = cart.sites[i];
							site._cart = cart;
							if(!site.add_to_cart || site.add_to_cart.length === 0) continue;

							// Iterate through the products and process them one by one
							for(var j = 0; j < site.add_to_cart.length; j++){
								var product = site.add_to_cart[j];

								var paramGroup = {
									product: product,
									site: site,
									cart: cart,
									serviceInstance: self
								};

								var processPromise = WinJS.Promise.wrap(paramGroup)
									.then(Twotapjs.Utilities.processRequiredFieldsAsync)
									.then(Twotapjs.Utilities.createRelationshipsAsync)
									.then(Twotapjs.Utilities.createObservableCollectionsAsync);
								promises.push(processPromise);
							}
						}

						// Return the singular, processed cart object
						return WinJS.Promise.join(promises).then(function(){
							return cart;
						});
					});
				},
				observableListType: function(){
					return [];
				},
				clickOption: function(option){
					if(!option || !(option instanceof Twotapjs.Models.SelectOneModelOption)){
						throw new Error("ClickOption: Parameter not a SelectOneModelOption");
					}

					// Set this option as selected on its parent
					var parentSelectOneModel = option._parentModel ? option._parentModel : option.parentModel;
					parentSelectOneModel.selected = option;

					// Grab the product
					var product = parentSelectOneModel._product;
					if(!product) return;

					if(!option.dep || option.dep.length === 0){
						return;
					}
					
					// Iterate through each dependant
					for(var i = 0; i < option.dep.length; i++){
						var dependant = option.dep[i];
						var source = undefined;

						// Look up the dependant in the toplevel
						for(var j = 0; j < product.required_fields.length; j++){
							var topLevelField = product.required_fields[j];

							if(topLevelField.name === dependant.name){
								source = topLevelField;
								break;
							}
						}

						if(source === undefined) continue;

						// Clear the list for this dependant
						while(source.observableValues.length > 0) {
							source.observableValues.pop();
						}

						for(var k = 0; k < source.values.length; k++){
							var value = source.values[k];
							if(value.parentOption === option){
								source.observableValues.push(value);
							}
						}
					}
				},
				Purchase: function(cart, userDetails){
					var self = this;
					return new WinJS.Promise(function(ccb, ecb){
						if(!cart) return ecb(new Error("Purchase: Missing cart parameter"));
                        if(!(cart instanceof Twotapjs.Models.CartModel)) return ecb(new Error("Purchase: Invalid cart parameter"));

                        // After validation:
                        var purchaseModel = new Twotapjs.Models.PurchaseModel();
						ccb(purchaseModel.initialize({
							cart: cart,
							userDetails: userDetails
						}));
					});
				}
			}
		),
	});

})();
if (typeof module != 'undefined' && module.exports) {
	module.exports = Twotapjs;
}