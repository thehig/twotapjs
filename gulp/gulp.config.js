module.exports = function() {
	var config = {
		base: {
			source: './src'
			,temp: './tmp'
			,distro: './dst'
		}, 
		unit: {
			source: './tests/unit'
		}, 
		e2e: {
			source: './tests/e2e',
			servedir: './tmp/src',
			servecfg: {
				port: 3000
				// livereload: true,
				// ,directoryListing: true
				// ,open: true				
			}
		}
	}
	// console.log("Exporting config");	
	return config;
}