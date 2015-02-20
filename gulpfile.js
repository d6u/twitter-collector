var gulp   = require('gulp');
var $      = require('gulp-load-plugins')();
var merge  = require('merge-stream');
var config = require('config');

gulp.task('serve', function() {
  return $.nodemon({
    script: 'app-main/app.js',
    ext: 'js',
    env: config.get('env')
  })
  .on('restart', function() {
    console.log('===> Restarted!');
  });
});

gulp.task('clean', function () {
  return gulp.src(['dest'], {read: false}).pipe($.clean());
});

gulp.task('dest', ['clean'], function() {
  var ejsFilter = $.filter('**/*.ejs');

  var s1 = gulp.src(['app-main/{.*,**}', 'app-postgresql/{.*,**}'])
    .pipe(ejsFilter)
    .pipe($.ejs(config))
    .pipe($.rename(function(path) {
      path.extname = '';
    }))
    .pipe(ejsFilter.restore())
    .pipe(gulp.dest('dest'));

  var s2 = gulp.src('package.json').pipe(gulp.dest('dest/app'));

  return merge(s1, s2);
});

gulp.task('docker', ['dest'], function() {

  var cmd = process.env.NODE_ENV === 'production' ?
    'docker build --no-cache -t <%= file.path.slice(0, -11).split("/").pop() %> <%= file.path.slice(0, -11) %>':
    'docker build -t <%= file.path.slice(0, -11).split("/").pop() %> <%= file.path.slice(0, -11) %>';

  return gulp.src('dest/**/Dockerfile')
    .pipe($.shell([
      'echo "===>>> processing <%= file.path %> with cmd: '+cmd+'"',
      cmd
    ], {
      env: process.env
    }));
});
