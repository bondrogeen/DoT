'use strict';

var gulp = require('gulp'),
 gutil = require('gulp-util'),
 gzip = require('gulp-gzip'),
 cssmin = require('gulp-cssmin'),
 rename = require('gulp-rename'),
 uglify = require('gulp-uglify'),
 replace = require('gulp-replace'),
 htmlmin = require('gulp-htmlmin'),
 luaminify = require('gulp-luaminify'),
 rigger = require('gulp-rigger');

var path = {
 build: 'files/',
 src: {
  html: 'src/*.html',
  js: 'src/assets/js/**/*.js',
  style: 'src/assets/css/*.css',
  img: 'src/assets/images/**/*.*',
  lua: 'src/lua/**/*.*',
  info: 'src/assets/info/**/*.*',
  fonts: 'src/assets/fonts/**/*.*'
 },
 watch: {
  html: 'src/**/*.html',
  js: 'src/assets/js/*.js',
  style: 'src/assets/css/*.css',
  img: 'src/assets/images/**/*.*',
  lua: 'src/lua/**/*.*',
  info: 'src/assets/info/**/*.*',
  fonts: 'src/assets/fonts/**/*.*'
 },
 clean: './build'
};

var optionsDef = {
 collapseWhitespace: true,
 minifyCSS:true,
 removeComments:true,
 minifyJS:true
 };

function html () {
 return gulp.src(path.src.html)
  .pipe(rigger())
  .pipe(htmlmin(optionsDef))
  .pipe(replace('<?lua', '\n<?lua'))
  .pipe(gulp.dest(path.build));
};

function js() {
 return gulp.src(path.src.js)
  .pipe(rigger())
  .pipe(uglify())
  .pipe(gzip())
  .pipe(gulp.dest(path.build));
};

function style() {
 return gulp.src(path.src.style)
  .pipe(cssmin())
  .pipe(rename({basename: "style"}))
  .pipe(gzip())
  .pipe(gulp.dest(path.build));
};

function img() {
 return gulp.src(path.src.img)
  .pipe(gulp.dest(path.build));
};

function lua() {
    return gulp.src(path.src.lua)
        .pipe(luaminify())
        .pipe(gulp.dest(path.build));
};

function watch() {
  gulp.watch(path.watch.html, html);
  gulp.watch(path.watch.js, js);
  gulp.watch(path.watch.lua, lua);
  gulp.watch(path.watch.style, style);
}

gulp.task('build', gulp.parallel(html, js, style, img, lua));
gulp.task('watch', gulp.series(watch));
