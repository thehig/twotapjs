require('../lib/Utilities.js');
require('./ProductModel.js');

WinJS.Namespace.define("Twotapjs.Models", {
	SiteModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		info: function(item) {
			if(!item || !item.info) throw new Error("SiteModel: All sites must have 'info'");
			return item.info;
		}
	})
});