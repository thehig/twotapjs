require('../lib/Utilities.js');

WinJS.Namespace.define("Twotapjs.Models", {
	CartModel: WinJS.Class.derive(XboxJS.Data.DataModel, null, {

		unrecognised: function(item){
			return Twotapjs.Utilities.unrecognised(item, this, "CartModel: unrecognised keys in model: ", [
				'required_field_values'
				]);
		}
	})
});