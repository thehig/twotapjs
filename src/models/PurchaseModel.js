if (typeof module != 'undefined' && module.exports) {
	require('../lib/Utilities.js');
	require('./PurchaseModel.js');
}


(function PurchaseModelInit() {
	console.log('[+] Twotap Purchase Model 0.0.0');

	WinJS.Namespace.define("Twotapjs.Models", {
		PurchaseModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
			name: function(item) {
				// if (!item || !item.info || !item.info.name) throw new Error("PurchaseModel: All Purchases must have 'info.name'");
				// return item.info.name;
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