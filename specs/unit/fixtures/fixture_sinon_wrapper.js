module.exports = function(url, payload){
	var sinon = require('sinon');
	fakeServer = sinon.fakeServer.create();
	
	fakeServer.autoRespond = true;
	fakeServer.respondWith("GET", url, [200, { "Content-Type": "application/json" }, JSON.stringify(payload)]);
	return fakeServer;
}