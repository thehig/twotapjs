require('../lib/Utilities.js');

WinJS.Namespace.define("Twotapjs.Models", {
	SelectOneModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		name: function(item){
			return item.name ? item.name : "";
		},
		values: function(item){
			if(!item || !item.required_field_values) return [];
			var results = [];
			for(var i = 0; i < item.required_field_values.length; i++){
				var field_value = item.required_field_values[i];
				var optionmodel = new Twotapjs.Models.SelectOneModelOption();
				optionmodel.initialize(field_value);
				results.push(optionmodel);
			}
			return results;
		}
	}),
	SelectOneModelOption: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		price: function(item){
			return item.price ? item.price : "";
		},
		image: function(item){
			return item.image ? item.image : "";	
		},
		alt_images: function(item){
			return item.alt_images;
		},
		value: function(item){
			return item.value ? item.value : "";
		},
		text: function(item){
			return item.text ? item.text : "";
		},
		extra_info: function(item){
			return item.extra_info ? item.extra_info : "";
		}
	})
});