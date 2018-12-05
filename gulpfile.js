'use strict';

var gulp = require('gulp'),
 watch = require('gulp-watch'),
 gutil = require('gulp-util'),
 gzip = require('gulp-gzip'),
 cssmin = require('gulp-cssmin'),
 rename = require('gulp-rename'),
 uglify = require('gulp-uglify'),
 rigger = require('gulp-rigger');


var path = {
 build: {
  html: 'files/',
  js: 'files/',
  css: 'files/',
  lua: 'files/',
  img: 'files/'
 },
 src: {
  html: 'src/*.html',
  js: 'src/assets/js/**/*.js',
  style: 'src/assets/css/*.css',
  img: 'src/assets/images/**/*.*',
  lua: 'src/lua/**/*.*',
  fonts: 'src/assets/fonts/**/*.*'
 },
 watch: {
  html: 'src/**/*.html',
  js: 'src/assets/js/*.js',
  style: 'src/assets/css/*.css',
  img: 'src/assets/images/**/*.*',
  lua: 'src/lua/**/*.*',
  fonts: 'src/assets/fonts/**/*.*'
 },
 clean: './build'
};

gulp.task('html:build', function () {
 gulp.src(path.src.html)
  .pipe(rigger())
  .pipe(gulp.dest(path.build.html));
});

gulp.task('js:build', function () {
 gulp.src(path.src.js)
  .pipe(rigger())
  .pipe(uglify())
  .pipe(gzip())
  .pipe(gulp.dest(path.build.js));
});

gulp.task('lua:build', function () {
 gulp.src(path.src.lua)
  .pipe(gulp.dest(path.build.lua));
});

gulp.task('css:build', function () {
 gulp.src(path.src.style)
  //        .pipe(rigger())
  .pipe(cssmin())
  .pipe(rename({basename: "style"}))
  .pipe(gzip())
  .pipe(gulp.dest(path.build.css));
});

gulp.task('img:build', function () {
 gulp.src(path.src.img)
  .pipe(gulp.dest(path.build.img));
});


gulp.task('build', [
    'html:build',
    'lua:build',
    'js:build',
    'css:build',
    'img:build'
]);

gulp.task('watch', function () {
 watch([path.watch.html], function (event, cb) {
  gulp.start('html:build');
 })

 watch([path.watch.js], function (event, cb) {
  gulp.start('js:build');
 });

 watch([path.watch.lua], function (event, cb) {
  gulp.start('lua:build');
 });

 watch([path.watch.style], function (event, cb) {
  gulp.start('css:build');
 });

});
