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

var istanbul = require('gulp-istanbul');

gulp.task('pre-istanbul', ['source'], function () {
	var basicSourceFiles = [
		config.base.temp + '/src/*.js',
		config.base.temp + '/src/models/*.js'
	];

	return gulp.src(basicSourceFiles)
    // Covering files
    .pipe(istanbul())
    // Force `require` to return covered files
    .pipe(istanbul.hookRequire());
});

gulp.task('istanbul', ['unit-coffee', 'unit-copy-js','pre-istanbul'], function () {
	var unitTestFiles = [
		config.base.temp + "/specs/unit/*.js"
	];

	return gulp.src(unitTestFiles)
    .pipe(require('gulp-mocha')())
    // Creating the reports after tests ran
    .pipe(istanbul.writeReports())
    // Enforce a coverage of at least 90%
    .pipe(istanbul.enforceThresholds({ thresholds: { global: 75 } }));
});