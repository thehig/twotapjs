require('../lib/Utilities.js');

WinJS.Namespace.define("Twotapjs.Models", {
	ProductModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, { 
		name: function(item){
			// console.log("NAME");
			return item.name;
		}
		// Instance members
	})
});