// https://github.com/aseemk/requireDir#tips
// Note: these functions self-invoke when required
module.exports = {
	'all': require('require-dir')()   // defaults to '.'
	,'all_array': function(){
		var all = require('require-dir')();
		return Object.keys(all).map(function(key){
			return all[key];
		}).reduce(function(prev, current){
			// If it's an array, concat to output
			if(Array.isArray(current)) return prev.concat(current);
			// If it's an object, push to output
			prev.push(current);
			return prev;
		}, []);
	}()
}