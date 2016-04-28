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
		},

		failed_to_add_to_cart: function(item) {
			if (!item || !item.failed_to_add_to_cart) return [];
			return Object.keys(item.failed_to_add_to_cart).map(function(productID){
				var product = item.failed_to_add_to_cart[productID];
				if(!product) return;

				product._id = productID;
				var model = new Twotapjs.Models.FailedProductModel();
				model.initialize(product);
				return model;
			});
		},
		currency_format: function(item){
			if(!item || !item.currency_format) throw new Error("SiteModel: All sites must have 'currency_format'");
			return item.currency_format;			
		},

		coupon_support: function(item){
			// if(!item || !item.coupon_support) throw new Error("SiteModel: All sites must have 'coupon_support'");
			return item.coupon_support ? item.coupon_support : false;			
		},
		gift_card_support: function(item){
			// if(!item || !item.gift_card_support) throw new Error("SiteModel: All sites must have 'gift_card_support'");
			return item.gift_card_support ? item.gift_card_support : false;			
		},
		checkout_support: function(item){
			if(!item || !item.checkout_support) throw new Error("SiteModel: All sites must have 'checkout_support'");
			return item.checkout_support;			
		},
		shipping_countries_support: function(item){
			if(!item || !item.shipping_countries_support) throw new Error("SiteModel: All sites must have 'shipping_countries_support'");
			return item.shipping_countries_support;			
		},
		billing_countries_support: function(item){
			if(!item || !item.billing_countries_support) throw new Error("SiteModel: All sites must have 'billing_countries_support'");
			return item.billing_countries_support;			
		},
		returns: function(item){
			if(!item || !item.returns) throw new Error("SiteModel: All sites must have 'returns'");
			return item.returns;			
		},
		
		unrecognised: function(item){
			return Twotapjs.Utilities.unrecognised(item, this, "SiteModel: unrecognised keys in site: ", [
				'info'
			]);
		}
	})
});