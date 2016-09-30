if (typeof module != 'undefined' && module.exports) {
	require('../lib/Utilities.js');
	require('./PurchaseModel.js');
}


(function PurchaseModelInit() {
	console.log('[+] Twotap Purchase Model 0.0.0');

	WinJS.Namespace.define("Twotapjs.Models", {
		PrePurchaseModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			message: function(item) {
				// if (!item || !item.info || !item.info.name) throw new Error("PurchaseModel: All Purchases must have 'info.name'");
				// return item.info.name;
				return item.message ? item.message : undefined;
			},
			purchase_id: function(item){
				if (!item || !item.purchase_id || !item.purchase_id) throw new Error("PrePurchaseModel: All Purchases must have 'purchase_id'");
				return item.purchase_id;
			},
			updated_at: function(item){
				if (!item || !item.updated_at || !item.updated_at) throw new Error("PrePurchaseModel: All Purchases must have 'updated_at'");
				return new Date(item.updated_at);
			}
			// unrecognised: function(item) {
			// 	return Twotapjs.Utilities.unrecognised(item, this, "PurchaseModel: unrecognised keys in Purchase: ", [
			// 		'info',
			// 		'_id'
			// 	]);
			// }
		}),
		PurchaseModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			purchase_id: function(item){
				if (!item || !item.purchase_id) throw new Error("PurchaseModel: All Purchases must have 'purchase_id'");
				return item.purchase_id;
			},
			created_at: function(item){
				if (!item || !item.created_at) throw new Error("PurchaseModel: All Purchases must have 'created_at'");
				return new Date(item.created_at);
			},
			destination: function(item){
				if (!item || !item.destination) throw new Error("PurchaseModel: All Purchases must have 'destination'");
				return item.destination;
			},
			message: function(item){
				if (!item || !item.message || !item.message) throw new Error("PurchaseModel: All Purchases must have 'message'");
				return item.message;
			},
			final_message: function(item){
				return item.final_message;
			},
			confirm_with_user: function(item){
				// if (!item || item.confirm_with_user == undefined) throw new Error("PurchaseModel: All Purchases must have 'confirm_with_user'");
				return item.confirm_with_user;
			},
			session_finishes_at: function(item){
				// if (!item || !item.session_finishes_at) throw new Error("PurchaseModel: All Purchases must have 'session_finishes_at'");
				return new Date(item.session_finishes_at);
			},
			total_prices: function(item){
				if (!item || item.total_prices == undefined) throw new Error("PurchaseModel: All Purchases must have 'total_prices'");
				return item.total_prices;
			},
			fake_confirm: function(item){
				return item.fake_confirm;
			},
			pending_confirm: function(item){
				return item.pending_confirm;
			},
			notes: function(item){
				return item.notes ? item.notes : undefined;
			},
			used_profiles: function(item){
				return item.used_profiles ? item.used_profiles : undefined;
			},
			test_mode: function(item){
				return item.test_mode;
			},
			// unrecognised: function(item) {
			// 	return Twotapjs.Utilities.unrecognised(item, this, "PurchaseModel: unrecognised keys in Purchase: ", [
			// 		'info',
			// 		'_id'
			// 	]);
			// }

			sites: function(item) {
				if (!item || !item.sites) throw new Error("PurchasseModel: All purchases must have 'sites'");
				return Object.keys(item.sites).map(function(siteId) {
					var site = item.sites[siteId];
					if (!site) return;

					site._id = siteId;
					var model = new Twotapjs.Models.PurchaseSiteModel();
					model.initialize(site);
					return model;
				});
			},

		}),
		PurchaseSiteModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			info: function(item){
				return item.info;
			},
			prices: function(item){
				return item.prices;
			},
			details: function(item){
				return item.details;
			},
			status: function(item){
				return item.status;
			},
			order_id: function(item){
				return item.order_id;
			},
			products: function(item) {
				if (!item || !item.products) return [];
				return Object.keys(item.products).map(function(productID) {
					var product = item.products[productID];
					if (!product) return;

					product._id = productID;
					var model = new Twotapjs.Models.PurchaseProductModel();
					model.initialize(product);
					return model;
				});
			},
			id: function(item){
				return item._id;
			},
		}),
		PurchaseProductModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			title: function(item){
				return item.title;
			},
			price: function(item){
				return item.price;
			},
			image: function(item){
				return item.image;
			},
			alt_images: function(item){
				return item.alt_images;
			},
			description: function(item){
				return item.description;
			},
			categories: function(item){
				return item.categories;
			},
			weight: function(item){
				return item.weight;
			},
			pickup_support: function(item){
				return item.pickup_support;
			},
			required_field_names: function(item){
				return item.required_field_names;
			},
			url: function(item){
				return item.url;
			},
			original_price: function(item){
				return item.original_price;
			},
			discounted_price: function(item){
				return item.discounted_price;
			},
			status: function(item){
				return item.status;
			},
			clean_url: function(item){
				return item.clean_url;
			},
			original_url: function(item){
				return item.original_url;
			},
			quantity: function(item){
				return item.quantity;
			},
			input_fields: function(item){
				return item.input_fields;
			},
			id: function(item){
				return item._id;
			},
		}),
	});
})();
