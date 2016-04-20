var WinJS = require('node-winjs');

WinJS.Namespace.define('Twotapjs', {
	DataProvider: WinJS.Class.define(function(){}, {}, {})
});

if(module && module.exports)
	module.exports = Twotapjs;