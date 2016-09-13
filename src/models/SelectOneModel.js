if (typeof module != 'undefined' && module.exports) {
	require('../lib/Utilities.js');
}


(function selectOneModelInit() {
	console.log('[+] Twotap SelectOne Model 0.1.0');

	WinJS.Namespace.define("Twotapjs.Models", {
		SelectOneModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			name: function(item) {
				if (!item || !item.name) throw new Error("SelectOneModel: All SelectOneModels must have 'name'");

				return item.name;
			},
			values: function(item) {
				// Note: This causes issue when you have 'quantity' as it is a special case with no values

				// if(!item || !item.values) throw new Error("SelectOneModel: All SelectOneModels must have 'values'");

				if (!item || !item.required_field_values) return [];
				var results = [];
				for (var i = 0; i < item.required_field_values.length; i++) {
					var field_value = item.required_field_values[i];
					var optionmodel = new Twotapjs.Models.SelectOneModelOption();
					optionmodel.initialize(field_value);
					optionmodel.parentModel = this;
					results.push(optionmodel);
				}
				return results;
			},
			unrecognised: function(item) {
				return Twotapjs.Utilities.unrecognised(item, this, "SelectOneModel: unrecognised keys in model: ", [
					'required_field_values'
				]);
			}
		}),
		SelectOneModelOption: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			price: function(item) {
				if (!item || !item.price) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'price'");
				return item.price === 'NA' ? undefined : item.price;
			},
			image: function(item) {
				if (!item || !item.image) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'image'");
				return item.image === 'NA' ? undefined : item.image;
			},
			alt_images: function(item) {
				return item.alt_images ? item.alt_images : [];
			},
			value: function(item) {
				if (!item || !item.value) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'value'");
				return item.value;
			},
			text: function(item) {
				if (!item || !item.text) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'text'");
				return item.text;
			},
			extra_info: function(item) {
				if (!item || item.extra_info === undefined) throw new Error("SelectOneModelOption: All SelectOneModelOptions must have 'extra_info'");
				return item.extra_info === 'NA' ? undefined : item.extra_info;
			},
			dep: function(item) {
				if (!item || !item.dep) return undefined;
				var keys = Object.keys(item.dep);
				if (!keys || keys.length === 0) return undefined;
				var deps = [];

				keys.forEach(function(key) {
					var value = item.dep[key];
					if (!value) throw new Error("SelectOneModelOption: Invalid value for dep: " + key);
					var inputmodel = new Twotapjs.Models.SelectOneModel();

					inputmodel.initialize({
						"name": key,
						"required_field_values": value
					});
					deps.push(inputmodel);
				});

				return deps;
			},
			unrecognised: function(item) {
				return Twotapjs.Utilities.unrecognised(item, this, "SelectOneModelOption: unrecognised keys in model: ", [
					'required_field_values', 'weight'
				]);
			}
		}),
		TextModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			name: function(item) {
				if (!item || !item.name) throw new Error("TextModel: All SelectOneModels must have 'name'");

				return item.name;
			},
			unrecognised: function(item) {
				return Twotapjs.Utilities.unrecognised(item, this, "TextModel: unrecognised keys in model: ", [
					'required_field_values'
				]);
			}
		})
	});

})();