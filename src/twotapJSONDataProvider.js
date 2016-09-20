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
	console.log('[+] Twotap JSON Data Provider 0.1.3');

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

                    	if(!userDetails) return ecb(new Error("Purchase: Missing User Details parameter"));

                        var mandatoryUserKeys = ["email", "shipping_first_name", "shipping_last_name", "shipping_address", "shipping_city", "shipping_state", "shipping_country", "shipping_zip", "shipping_telephone", "billing_first_name", "billing_last_name", "billing_address", "billing_city", "billing_state", "billing_country", "billing_zip", "billing_telephone", "card_type", "card_number", "card_name", "expiry_date_year", "expiry_date_month", "cvv"]; 

                        for(var i = 0; i < mandatoryUserKeys.length; i++){
                        	var key = mandatoryUserKeys[i];
                        	if(!userDetails[key]) return ecb(new Error("Purchase: Missing User Details parameter: " + key));
                        }

                        // Create the top level body of the purchase object
                        var purchaseBody = {
                        	cart_id: cart.cart_id,
                        	fields_input: {}
                        };

                        // For each site
                        for(var j = 0; j < cart.sites.length; j++)
                        {
                        	var site = cart.sites[j];

                        	var sitefields = {
                        		addToCheckout: {}
                        	}

                        	// For each product
                        	for(var k = 0; k < site.add_to_cart.length; k++){
                        		var product = site.add_to_cart[k];
                        		var productSelections = {};

                        		// For each option
                        		for(var m = 0; m < product.required_fields.length; m++){
                        			var option = product.required_fields[m];
									if(!option.selected) return ecb(new Error("Purchase: Option not selected - " + product.title + " - " + option.name));
									// Attach the option to the product
                        			productSelections[option.name] = option.selected.text;
                        		}

                        		// Attach the product to the site
                        		sitefields.addToCheckout[product.id] = productSelections;
                        	}

                        	// Attach the site to the purchase
                        	purchaseBody.fields_input[site.id] = sitefields;
                        }

                        ccb(purchaseBody);
					});
				}
			}
		),
	});

})();
if (typeof module != 'undefined' && module.exports) {
	module.exports = Twotapjs;
}