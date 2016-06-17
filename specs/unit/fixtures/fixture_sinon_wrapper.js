module.exports = function(url, payload){
	// Uncomment to disable the wrapper
	// return {
	// 	restore: function(){}
	// }

	var sinon = require('sinon');
	fakeServer = sinon.fakeServer.create();
	
	fakeServer.autoRespond = true;
	fakeServer.respondWith("GET", url, function(request){
		console.log("=== SINON WRAPPER INTERCEPT FOR "+ url +" ===");
		request.respond(200, { "Content-Type": "application/json" }, JSON.stringify(payload));
	});

	// fakeServer.respondWith("GET", url, [200, { "Content-Type": "application/json" }, JSON.stringify(payload)]);
	return fakeServer;
}