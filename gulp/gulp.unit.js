var gulp = require('gulp');
var gutil = require('gulp-util');
var config = require('./gulp.config.js')();

gulp.task('unit', ['unit-mocha']);

gulp.task('unit-clean-temp', function() {
	var tempUnitFiles = [
		config.base.temp + "/unit"
	];

	return require('del')(tempUnitFiles).then(function(paths) {
		if (paths && paths.length)
			gutil.log('\tdeleted ', paths.join(', '));
	});
});

gulp.task('unit-coffee', ['unit-clean-temp'], function() {
	var sourcemaps = require('gulp-sourcemaps');

	var unitTestFiles = [
		config.unit.source + "/**/*.coffee"
	];

	return gulp.src(unitTestFiles)
		.pipe(sourcemaps.init())
		.pipe(require('gulp-coffee')().on('error', gutil.log))
		.pipe(sourcemaps.write('maps'))
		.pipe(gulp.dest(config.base.temp + '/unit'));
});

gulp.task('unit-mocha', ['unit-coffee', 'source'], function() {
	var unitTestFiles = [
		config.base.temp + "/unit/*.js"
	];
	
	return gulp.src(unitTestFiles)
		.pipe(require('gulp-mocha')({
			bail: true
		}));
});