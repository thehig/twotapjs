require('../lib/Utilities.js');
require('./SelectOneModel.js');

WinJS.Namespace.define("Twotapjs.Models", {
	ProductModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		title: function(item) {
			return item.title ? item.title : "";
		},
		image: function(item) {
			return item.image ? item.image : undefined;
		},
		price: function(item) {
			return item.price ? item.price : "";
		},
		alt_images: function(item) {
			return item.alt_images ? item.alt_images : undefined;
		},
		url: function(item) {
			return item.url ? item.url : undefined;
		},
		original_url: function(item) {
			return item.original_url ? item.original_url : undefined;
		},
		clean_url: function(item) {
			return item.clean_url ? item.clean_url : undefined;
		},
		status: function(item) {
			return item.status ? item.status : undefined;
		},
		returns: function(item) {
			return item.returns ? item.returns : undefined;
		},
		description: function(item) {
			return item.description ? item.description : "";
		},
		required_fields: function(item){
			if(!item || !item.required_fields || !item.required_field_names) return [];

			var results = [];

			// Separate the required fields object
			for(var i = 0; i < item.required_field_names.length; i++){
				var name = item.required_field_names[i];
				if(!name) break;
				var required_field = item.required_fields[name];
				if(!required_field || !required_field.data) break;

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
				if(!input) break;

				if(input.input_type && input.input_type === "select-one" && 
					input.input_name && input.input_name === "SELECT"){
					// Now we know we have a select-one data type, we know what type of model to create
					var datamodel = new Twotapjs.Models.SelectOneModel();
					datamodel.initialize({
						"name": name,
						"required_field_values": required_field_values
					});
					results.push(datamodel);
				} else {
					throw new Error("Unrecognised item type");
				}
			}
			
			return results;
		},
		shopify: function(item){
			if(!item || !item.shopify_id) return undefined;

			var result = {
				id: item.shopify_id,
				variants: item.shopify_variants
			}

			return result;
		}
	})
});