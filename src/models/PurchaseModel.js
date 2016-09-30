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
			confirm_with_user: function(item){
				if (!item || item.confirm_with_user == undefined) throw new Error("PurchaseModel: All Purchases must have 'confirm_with_user'");
				return item.confirm_with_user;
			},
			session_finishes_at: function(item){
				if (!item || !item.session_finishes_at) throw new Error("PurchaseModel: All Purchases must have 'session_finishes_at'");
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
		})
	});
})();