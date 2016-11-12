if (typeof module != 'undefined' && module.exports) {
	require('../lib/Utilities.js');
}


(function cartModelInit() {
	console.log('[+] Twotap Cart Model 0.1.2');

	WinJS.Namespace.define("Twotapjs.Models", {
		CartModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			user_id: function(item) {
				// if(!item || !item.user_id) throw new Error("CartModel: All carts must have 'user_id'");
				return item.user_id ? item.user_id : undefined;
			},
			cart_id: function(item) {
				if (!item || !item.cart_id) throw new Error("CartModel: All carts must have 'cart_id'");
				return item.cart_id;
			},
			country: function(item) {
				// if (!item || !item.country) throw new Error("CartModel: All carts must have 'country'");
				return item.country ? item.country : "";
			},
			message: function(item) {
				if (!item || !item.message) throw new Error("CartModel: All carts must have 'message'");
				return item.message;
			},
			description: function(item) {
				// if (!item || !item.description) throw new Error("CartModel: All carts must have 'description'");
				return item.description ? item.description : "";
			},
			unknown_urls: function(item) {
				// if (!item || !item.unknown_urls) throw new Error("CartModel: All carts must have 'unknown_urls'");
				return item.unknown_urls ? item.unknown_urls : [];
			},
			sites: function(item) {
				// if (!item || !item.sites) throw new Error("CartModel: All carts must have 'sites'");
				return Object.keys(item.sites).map(function(siteId) {
					var site = item.sites[siteId];
					if (!site) return;

					site._id = siteId;
					var model = new Twotapjs.Models.SiteModel();
					model.initialize(site);
					return model;
				});
			},
			unrecognised: function(item) {
				return Twotapjs.Utilities.unrecognised(item, this, "CartModel: unrecognised keys in model: ", [
					'stored_field_values', 'notes'
				]);
			},
			id: function(item) {
				return item._id;
			}
		})
	});

})();