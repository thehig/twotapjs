var gulp = require('gulp');
var gutil = require('gulp-util');
var config = require('./gulp/gulp.config.js')();

gulp.task('default', function(){
	return require('gulp-task-listing').withFilters(null, 'default')();
});

// Load everything in the gulp folder
require('require-dir')('./gulp');