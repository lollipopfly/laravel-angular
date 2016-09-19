var gulp          = require('gulp'),
    slim          = require("gulp-slim"),
    coffee        = require('gulp-coffee'),
    sass          = require('gulp-sass'),

    postcss       = require('gulp-postcss'),
    pxtorem       = require('postcss-pxtorem'),
    colorFunction = require("postcss-color-function"),
    postcssExtend = require('postcss-sass-extend'),
    selectors     = require('postcss-custom-selectors'),
    autoprefixer  = require('autoprefixer'),
    size          = require('postcss-size'),

    sourcemaps    = require('gulp-sourcemaps'),
    concat        = require('gulp-concat'),
    uglify        = require('gulp-uglify'),

    plumber       = require('gulp-plumber'),
    gutil         = require('gulp-util'),
    debug         = require('gulp-debug'),
    notify        = require("gulp-notify");

/*------------------------------------*\
 Slim
\*------------------------------------*/
gulp.task('slim', function(){
  gulp.src("resources/views/**/*.slim")
    .pipe(slim({
      pretty: true,
      options: "attr_list_delims={'(' => ')', '[' => ']'}",

    }))
    .on('error', function (message) {
        gutil.log(gutil.colors.red(message));
        this.emit('end');
    })
    .pipe(debug({title: 'render-slim:'}))
    .pipe(gulp.dest("public/views/"));
});

/*------------------------------------*\
 Sass
\*------------------------------------*/
gulp.task('sass', function() {
  var processors = [
      autoprefixer({ browsers: ['last 20 versions'] }),
      selectors,
      postcssExtend,
      size,
      colorFunction,
      //pxtorem({
      //    replace: true
      //})
  ];

  return gulp.src([
    'resources/assets/sass/app.scss'
    ])
    .pipe(concat('style.css'))
    .pipe(sass(
    {
      // outputStyle: 'compressed'
    }
    ))
    .on('error', function (message) {
      gutil.log(gutil.colors.red(message));
      this.emit('end');
    })
    .pipe(postcss(processors))
    .pipe(debug({title: 'sass:'}))
    .pipe(gulp.dest('public/css/'));
});


/*------------------------------------*\
 Uglify
\*------------------------------------*/

gulp.task('compress-js', function() {
  return gulp.src([
    'node_modules/angular/angular.js',
    'node_modules/angular-ui-router/release/angular-ui-router.js',
    'node_modules/satellizer/dist/satellizer.js',
  ])
    .pipe(plumber())
    .pipe(concat('global.min.js'))
    //.pipe(uglify())
    .pipe(debug({title: 'compress-js:'}))
    .pipe(gulp.dest('public/js/'));
});

/*------------------------------------*\
 Coffee
\*------------------------------------*/


gulp.task('compile-coffee', function() {
  gulp.src('resources/assets/js/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .on('error', function (message) {
      gutil.log(gutil.colors.red(message));
      this.emit('end');
    })
    .pipe(sourcemaps.write())
    .pipe(concat('app.js'))
    .pipe(debug({title: 'compile-coffee:'}))
    .pipe(gulp.dest('public/js'));
});

/*------------------------------------*\
 Notify
\*------------------------------------*/

gulp.task('notify', function(a) {
  var date = new Date();
  gulp.src("public/build/css/style.css")
    .pipe(notify("Css was compiled! at " + date));
});

/*------------------------------------*\
 Run default gulp tasks
 \*------------------------------------*/

gulp.task('default', [
  'sass',
  'slim',
  'compress-js',
  'compile-coffee',
  'watch'
]);

/*------------------------------------*\
 Watch
\*------------------------------------*/

gulp.task('watch', function() {
  gulp.watch('resources/views/**/*.slim', ['slim', 'notify']);
  gulp.watch('resources/assets/sass/**/*.scss', { interval: 500 }, ['sass', 'notify']);
  gulp.watch('resources/assets/js/**/*.coffee', ['compile-coffee', 'notify']);
});