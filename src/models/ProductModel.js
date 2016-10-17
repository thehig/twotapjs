if (typeof module != 'undefined' && module.exports) {
	require('../lib/Utilities.js');
	require('./SelectOneModel.js');
}


(function productModelInit() {
	console.log('[+] Twotap Product Model 0.1.0');

	WinJS.Namespace.define("Twotapjs.Models", {
		ProductModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			title: function(item) {
				if (!item || !item.title) throw new Error("ProductModel: All products must have 'title'");
				return item.title;
			},
			image: function(item) {
				if (!item || !item.image) throw new Error("ProductModel: All products must have 'image'");
				return item.image;
			},
			price: function(item) {
				if (!item || !item.price) throw new Error("ProductModel: All products must have 'price'");
				return item.price;
			},
			alt_images: function(item) {
				return item.alt_images ? item.alt_images : undefined;
			},
			url: function(item) {
				if (!item || !item.url) throw new Error("ProductModel: All products must have 'url'");
				return item.url;
			},
			original_url: function(item) {
				if (!item || !item.original_url) throw new Error("ProductModel: All products must have 'original_url'");
				return item.original_url;
			},
			clean_url: function(item) {
				if (!item || !item.clean_url) throw new Error("ProductModel: All products must have 'clean_url'");
				return item.clean_url;
			},
			status: function(item) {
				if (!item || !item.status) throw new Error("ProductModel: All products must have 'status'");
				if (item.status !== 'done') throw new Error("ProductModel: Product status is not 'done'");
				return item.status;
			},
			returns: function(item) {
				return item.returns ? item.returns : undefined;
			},
			description: function(item) {
				if (!item || !item.description) return "";
				return item.description;
			},
			required_fields: function(item) {
				if (!item || !item.required_fields || !item.required_field_names) return [];

				var results = [];

				// Separate the required fields object
				for (var i = 0; i < item.required_field_names.length; i++) {
					var name = item.required_field_names[i];
					if (!name) break;
					var required_field = item.required_fields[name];
					if (!required_field || !required_field.data) break;

					// required field is now 
					// {
					// 	"data": [{
					// 		"input_type": "select-one",
					// 		"input_name": "SELECT"
					// 	}]
					// }

					// Note: In the case of quantity, this will be undefined
					var required_field_values = item.required_field_values[name];

					var input = required_field.data[0];
					if (!input) break;

					if (input.input_type && input.input_type === "select-one" &&
						input.input_name && input.input_name === "SELECT") {
						// Now we know we have a select-one data type, we know what type of model to create
						var inputmodel = new Twotapjs.Models.SelectOneModel();
						inputmodel.initialize({
							"name": name,
							"required_field_values": required_field_values
						});
						results.push(inputmodel);
					} else if (input.input_type && input.input_type === "text" &&
						input.input_name && input.input_name === "INPUT") {

						if(name === 'quantity'){
							var quantityModel = new Twotapjs.Models.SelectOneModel();

							var pseudoValues = [];
							// Not sure if quantity should start at 0 so you can remove items from the cart without starting over
							for(var quantityCount = 1; quantityCount <= 10; quantityCount++){
								// This is a horrible way to create mock values that will pass the existence checks
								pseudoValues.push({
									price: "NA",
									image: "NA",
									value: quantityCount,
									text: quantityCount,
									extra_info: "NA"
								});
							}

							quantityModel.initialize({
								"name": name,
								"required_field_values": pseudoValues
							});
							results.push(quantityModel);
						} else {
							var textmodel = new Twotapjs.Models.TextModel();
							textmodel.initialize({
								"name": name,
								"required_field_values": required_field_values
							});
							results.push(textmodel);
						}

					} else {
					    // Hack around some new Twotap type: "ProductModel: Unrecognised item type text / SELECT"
						// throw new Error("ProductModel: Unrecognised item type " + input.input_type + " / " + input.input_name);
					}
				}

				return results;
			},
			shopify: function(item) {
				if (!item || !item.shopify_id) return undefined;

				var result = {
					id: item.shopify_id,
					variants: item.shopify_variants
				};

				return result;
			},
			unrecognised: function(item) {
				return Twotapjs.Utilities.unrecognised(item, this, "ProductModel: unrecognised keys in product: ", [
					'shopify_id',
					'shopify_variants',
					'required_field_values',
					'required_field_names',
					'original_price',
					'discounted_price',
					'pickup_support',
					'extra_info',
					'_id',
					'source',
                    'weight',
                    'categories',
                    'site_categories'
				]);
			},
			id: function(item) {
				return item._id;
			}
		}),
		FailedProductModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			title: function(item) {
				return item.title ? item.title : "";
			},
			price: function(item) {
				return item.price ? item.price : undefined;
			},
			url: function(item) {
				if (!item || !item.url) throw new Error("FailedProductModel: All failed products must have 'url'");
				return item.url;
			},
			original_url: function(item) {
				if (!item || !item.original_url) throw new Error("FailedProductModel: All failed products must have 'original_url'");
				return item.original_url;
			},
			clean_url: function(item) {
				if (!item || !item.clean_url) throw new Error("FailedProductModel: All failed products must have 'clean_url'");
				return item.clean_url;
			},
			status: function(item) {
				if (!item || !item.status) throw new Error("FailedProductModel: All failed products must have 'status'");
				return item.status;
			},
			description: function(item) {
				if (!item || !item.description) return "";
				return item.description;
			},
			image: function(item) {
				return item.image ? item.image : undefined;
			},
			id: function(item) {
				return item._id;
			},

			required_fields: function(item) {
				if (!item || !item.required_fields || !item.required_field_names) return [];

				var results = [];

				// Separate the required fields object
				for (var i = 0; i < item.required_field_names.length; i++) {
					var name = item.required_field_names[i];
					if (!name) break;
					var required_field = item.required_fields[name];
					if (!required_field || !required_field.data) break;

					// required field is now 
					// {
					// 	"data": [{
					// 		"input_type": "select-one",
					// 		"input_name": "SELECT"
					// 	}]
					// }

					if(!item.required_field_values) break;

					// Note: In the case of quantity, this will be undefined
					var required_field_values = item.required_field_values[name];
					var input = required_field.data[0];
					if (!input) break;

					if (input.input_type && input.input_type === "select-one" &&
						input.input_name && input.input_name === "SELECT") {
						// Now we know we have a select-one data type, we know what type of model to create
						var inputmodel = new Twotapjs.Models.SelectOneModel();
						inputmodel.initialize({
							"name": name,
							"required_field_values": required_field_values
						});
						results.push(inputmodel);
					} else if (input.input_type && input.input_type === "text" &&
						input.input_name && input.input_name === "INPUT") {
						var textmodel = new Twotapjs.Models.TextModel();
						textmodel.initialize({
							"name": name,
							"required_field_values": required_field_values
						});
						results.push(textmodel);

						// console.log("[-] text/INPUT NOT YET SUPPORTED");
					} else {
						throw new Error("ProductModel: Unrecognised item type " + input.input_type + " / " + input.input_name);
					}
				}

				return results;
			},
			unrecognised: function(item) {
				// required_fields,discounted_price,original_price,pickup_support,required_field_values,required_field_names
				return Twotapjs.Utilities.unrecognised(item, this, "FailedProductModel: unrecognised keys in product: ", [
					'_id',
					'required_field_names',
					'required_field_values',
					'original_price',
					'discounted_price',
					'pickup_support',
					'alt_images',
                    'raw',
                    'categories'
				]);
			}
		})
	});

})();