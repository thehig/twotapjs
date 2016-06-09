var gulp = require('gulp');
var gutil = require('gulp-util');
var config = require('./gulp.config.js')();

gulp.task('unit', ['unit-mocha']);
gulp.task('debug', ['unit-mocha-debug']);

gulp.task('unit-clean-temp', function() {
	var tempUnitFiles = [
		config.base.temp + "/specs/unit"
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
		.pipe(gulp.dest(config.base.temp + '/specs/unit'));
});

gulp.task('unit-copy-js', ['unit-clean-temp'], function(){
	var fixtures = [
		config.unit.source + '/**/*.js',		
		config.unit.source + '/**/*.json'		
	];

	return gulp.src(fixtures)
		.pipe(gulp.dest(config.base.temp + '/specs/unit/'));
});

gulp.task('unit-mocha', ['unit-coffee', 'unit-copy-js', 'source'], function() {
	var unitTestFiles = [
		config.base.temp + "/specs/unit/*.js"
	];

	return gulp.src(unitTestFiles)
		.pipe(require('gulp-spawn-mocha')({
			bail: true
			,timeout: 30 * 1000
		}));
});


gulp.task('unit-mocha-debug', ['unit-coffee', 'unit-copy-js', 'source'], function() {
	var unitTestFiles = [
		config.base.temp + "/specs/unit/*.js"
	];

	return gulp.src(unitTestFiles)
		.pipe(require('gulp-spawn-mocha')({
			bail: true
			,timeout: 30 * 1000
			,debugBrk: true
		}));
});