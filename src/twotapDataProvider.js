require('./lib/Utilities.js');

WinJS.Namespace.define('Twotapjs', {
	DataProvider: WinJS.Class.derive(XboxJS.Data.DataProvider,
		function dataprovider_ctor(baseUrl) {
			// You must call the base class constructor to instantiate a DataProvider.
			this._baseDataProviderConstructor();
		}, {

		}
	)
});

if (module && module.exports)
	module.exports = Twotapjs;