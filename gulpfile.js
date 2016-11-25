var gulp = require('gulp'),
    rollup = require('rollup-stream'),
    source = require('vinyl-source-stream'),
    nodemon = require('gulp-nodemon')
    ;

gulp.task('lodash', function() {
  return rollup('lodash.rollup.config.js')
      .pipe(source('lodash-bundle.js'))
      .pipe(gulp.dest('./dist'))
      ;
});

gulp.task('mobx', function() {
  return rollup('mobx.rollup.config.js')
      .pipe(source('mobx-bundle.js'))
      .pipe(gulp.dest('./dist'))
      ;
});

gulp.task('rollup', function() {
  return rollup('rollup.config.js')
    .pipe(source('bundle.js'))
    .pipe(gulp.dest('./dist'))
    ;
});

gulp.task('watch', ['rollup'], function() {
  gulp.watch(['./client/*.js','./client/*.tag', './validation/*.js'], ['rollup']);
});

gulp.task('server', function () {
  nodemon({
    script: 'server/main.js',
    //args: ['--debug'],
    ext: 'js',
    watch: ['server/*.*'],
    env: { 'NODE_ENV': 'development' }
  })
})