module.exports = function(url, payload, outputLevel){
	// Uncomment to disable the wrapper
	// return {
	// 	restore: function(){}
	// }

	var sinon = require('sinon');
	fakeServer = sinon.fakeServer.create();
	
	fakeServer.autoRespond = true;
	if(outputLevel === 'none'){
		console.log("=== SINON WRAPPER INTERCEPT FOR \n\t"+ url);
		console.log("=== Further output is disabled");
	}
	fakeServer.respondWith("GET", url, function(request){
		switch(outputLevel){
			case 'short':
				console.log("SinonIntercept for " + url);
				break;
			case 'none':
				break;
			default:
				console.log("=== SINON WRAPPER INTERCEPT FOR "+ url +" ===");
				break;
			
		}
		request.respond(200, { "Content-Type": "application/json" }, JSON.stringify(payload));
	});

	// fakeServer.respondWith("GET", url, [200, { "Content-Type": "application/json" }, JSON.stringify(payload)]);
	return fakeServer;
}