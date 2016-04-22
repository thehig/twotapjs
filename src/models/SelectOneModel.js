require('../lib/Utilities.js');

WinJS.Namespace.define("Twotapjs.Models", {
	SelectOneModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		name: function(item){
			if(!item || !item.name) throw new Error("SelectOneModel: All SelectOneModels must have 'name'");

			return item.name;
		},
		values: function(item){
			// Note: This causes issue when you have 'quantity' as it is a special case with no values

			// if(!item || !item.values) throw new Error("SelectOneModel: All SelectOneModels must have 'values'");

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
			if(!item || !item.price) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'price'");
			return item.price;
		},
		image: function(item){
			if(!item || !item.image) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'image'");
			return item.image;	
		},
		alt_images: function(item){
			return item.alt_images ? item.alt_images : [];
		},
		value: function(item){
			if(!item || !item.value) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'value'");
			return item.value;
		},
		text: function(item){
			if(!item || !item.text) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'text'");
			return item.text
		},
		extra_info: function(item){
			if(!item || item.extra_info === undefined) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'extra_info'");
			return item.extra_info;
		}
	}),
	TextModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {

	})
});