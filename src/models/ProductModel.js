require('../lib/Utilities.js');

WinJS.Namespace.define("Twotapjs.Models", {
	ProductModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		title: function(item) {
			return item.title ? item.title : "";
		},
		image: function(item) {
			return item.image ? item.image : undefined;
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
		}
	})
});