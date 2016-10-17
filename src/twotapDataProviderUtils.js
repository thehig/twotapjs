if (typeof module != 'undefined' && module.exports) {
	require('./lib/Utilities.js');
	require('./models/ProductModel.js');
	require('./models/SelectOneModel.js');
	require('./models/SiteModel.js');
	require('./models/CartModel.js');
}

(function twotapClientInit() {
	console.log('[+] Twotap Data Provider Utilities 0.1.2x');

	WinJS.Namespace.define('Twotapjs.Utilities', {
		_defaultTimeout: 30000,

		unrecognised: function(source, target, errormessage, whitelist) {
			// Disable the unrecognised code entirely
			return [];

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

					// Sinon seems to not return "responseText", so this is exclusively for Sinon
					if(httpResult.response !== null && typeof httpResult.response === 'object' && httpResult.response.body !== null && typeof httpResult.response.body === 'object'){
						return [httpResult.response.body];
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
		processRequiredFieldsAsync: function(paramGroup){

			var self = this;
			return new WinJS.Promise(function(c, e, p){
				var product = paramGroup.product;

				var verbose = false;
				// Keep track of everything we've processed so far in the allList
				// This will have an array for each dropdown with every possible value in [values]
				var allList = [];

				// Iterate through the current products required fields
				for(var i = 0; i < product.required_fields.length; i++){
					var selectOneModel = paramGroup.serviceInstance.observableObjectType ? paramGroup.serviceInstance.observableObjectType(product.required_fields[i]) : product.required_fields[i];
					// If this required_field has values, push it into the all list and we're done
					if(selectOneModel.values && selectOneModel.values.length > 0){
						allList.push(selectOneModel);
						continue;					
					}

					// At this point, we know we do not have any values, and the name is not quantity
					if(verbose) console.log("[-] No values found for SelectOneModel: '" + selectOneModel.name);

					var allSelectOneModelInstances = [];

					// Go through all the previously processed items in the all list
					for(var j = 0; j < allList.length; j++){
						var parentSelectOneModel = allList[j];
						if(verbose) console.log("[*]\tSearching SelectOneModel: '" + parentSelectOneModel.name + "'");

						// Iterate through the values of the parent SelectOneModel
						for(var k = 0; k < parentSelectOneModel.values.length; k++){
							var selectOneModelOption = paramGroup.serviceInstance.observableObjectType ? paramGroup.serviceInstance.observableObjectType(parentSelectOneModel.values[k]) : parentSelectOneModel.values[k];
							if(verbose) console.log("[*]\t\tSearching SelectOneModelOption: '" + selectOneModelOption.text + "'");

							// If there are no deps, it's definitely not this one but we're not done searching so we want to continue the for loop
							if(!selectOneModelOption.dep) continue;

							// Iterate through the deps on the SelectOneModel
							for(var m = 0; m < selectOneModelOption.dep.length; m++){
								var childSelectOneModel = paramGroup.serviceInstance.observableObjectType ? paramGroup.serviceInstance.observableObjectType(selectOneModelOption.dep[m]) : selectOneModelOption.dep[m];
								// If this childSelectOneModel has the same name as the selectOneModel we were looking for, we have successfully found one instance
								if(childSelectOneModel.name === selectOneModel.name){
									// Add this instance to the growing collection of instances of this SelectOneModel with this name
									if(verbose) console.log("[*]\t\t\tFound SelectOneModelOption: '" + selectOneModel.name + "' in '"+ selectOneModelOption.text + "' with '" + childSelectOneModel.values.length + "' values");

									for(var n = 0; n < childSelectOneModel.values.length; n++){
										childSelectOneModel.values[n].parentOption = selectOneModelOption;
									}

									allSelectOneModelInstances.push(childSelectOneModel);
								}
							}						
						}
					}

					// We have now iterated through all the previous binding lists and have pulled out all the instances of the selectOneModel
					if(verbose) console.log("[+]\tSelectOneModel instances for : '" + selectOneModel.name + "' - '" + allSelectOneModelInstances.length + "'");

					// These objects however, are the SelectOneModels and not the SelectOneModelOptions, so we join them all together
					var allDeps = allSelectOneModelInstances.reduce(function(previous, current){
						return previous.concat(current.values);
					}, []);

					if(verbose) console.log("[+]\tSelectOneModelOption instances for: '" + selectOneModel.name + "' - '" + allDeps.length + "'");

					// Since the selectOneModel we're editing here is a reference to the SelectOneModel DataModel, and is passed by ref, inserting values here actually modifies the SelectOneModel in required_fields as well
					selectOneModel.values = allDeps;

					allList.push(selectOneModel);
				}
				c(paramGroup);	
			}.bind(this));
			
		},
		createRelationshipsAsync: function(paramGroup){
			return new WinJS.Promise(function(c, e, p){

				// Connect the product to the site and cart
				paramGroup.product._site = paramGroup.site;
				paramGroup.product._cart = paramGroup.cart;

				for(var i = 0; i < paramGroup.product.required_fields.length; i++){
					var currentModel = paramGroup.product.required_fields[i];

					// Connect the currentModel to the product, site and cart
					currentModel._product = paramGroup.product;
					currentModel._site = paramGroup.site;
					currentModel._cart = paramGroup.cart;

					// TextModels, i.e. quantity, don't have values
					if(!currentModel.values) continue;

					// Ensure that the parentModel has been bound to the topLevel version of the currentModel
					for(var j = 0; j < currentModel.values.length; j++){
						var currentOption = currentModel.values[j];
						currentOption._parentModel = currentModel;
					}
				}
				c(paramGroup);
			});
		},
		createObservableCollectionsAsync: function(paramGroup){
			return new WinJS.Promise(function(c, e, p){
				for(var i = 0; i < paramGroup.product.required_fields.length; i++){
					var selectOneModel = paramGroup.product.required_fields[i];

					// Create the placeholder observable collection
					selectOneModel.observableValues = paramGroup.serviceInstance.observableListType();

					if(selectOneModel.name === 'quantity'){
						for(var m = 0; m < selectOneModel.values.length; m++){
							selectOneModel.observableValues.push(selectOneModel.values[m]);
						}
					}

				}

				// Insert all the options from the first option, into the observable collection
				// 		thus setting up the initial state of the first dropdown
				var primaryOption = paramGroup.product.required_fields[0];
				if(primaryOption.values && primaryOption.values.length > 0){
					for(var j = 0; j < primaryOption.values.length; j++){
						primaryOption.observableValues.push(primaryOption.values[j]);
					}					
				}

				c(paramGroup);	
			});			
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