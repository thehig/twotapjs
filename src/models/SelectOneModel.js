require('../lib/Utilities.js');

WinJS.Namespace.define("Twotapjs.Models", {
	SelectOneModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		name: function(item){
			return item.name ? item.name : "";
		}
	}),
	SelectOneModelOption: WinJS.Class.derive(XboxJS.Data.DataModel, null, {
		
	})
});