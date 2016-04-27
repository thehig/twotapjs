require('../lib/Utilities.js');
require('./ProductModel.js');

WinJS.Namespace.define("Twotapjs.Models", {
	SiteModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		name: function(item) {
			if(!item || !item.info || !item.info.name) throw new Error("SiteModel: All sites must have 'info.name'");
			return item.info.name;
		},
		logo: function(item) {
			if(!item || !item.info || !item.info.logo) throw new Error("SiteModel: All sites must have 'info.logo'");
			return item.info.logo;
		},
		url: function(item) {
			if(!item || !item.info || !item.info.url) throw new Error("SiteModel: All sites must have 'info.url'");
			return item.info.url;
		},
		shipping_options: function(item) {
			if(!item || !item.shipping_options) throw new Error("SiteModel: All sites must have 'shipping_options'");
			
			return Object.keys(item.shipping_options).map(function(key){
				return {
					name:key,
					value:item.shipping_options[key]
				};
			});

		},
		add_to_cart: function(item) {
			if (!item || !item.add_to_cart)return [];
			return Object.keys(item.add_to_cart).map(function(productID){
				var product = item.add_to_cart[productID];
				if(!product) return;

				product._id = productID;
				var model = new Twotapjs.Models.ProductModel();
				model.initialize(product);
				return model;
			});
		}
	})
});