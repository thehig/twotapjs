// https://github.com/aseemk/requireDir#tips
// Note: these functions self-invoke when required
module.exports = {
	'all': require('require-dir')()   // defaults to '.'
	,'all_array': function(){
		var all = require('require-dir')();
		return Object.keys(all).reduce(function(output, key){
			return output.concat(all[key]);
		}, []);
	}()
	,'all_products_array': function(){
		var all = require('require-dir')();
		return Object.keys(all).reduce(function(output, key){
			if(key.indexOf('product') > -1)
				return output.concat(all[key]);
			return output;
		}, []);
	}()
}