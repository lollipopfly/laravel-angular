var gulp          = require('gulp'),

    coffee        = require('gulp-coffee'),
    sass          = require('gulp-sass'),
    postcss       = require('gulp-postcss'),
        size      = require('postcss-size'),

    sourcemaps    = require('gulp-sourcemaps')
    concat        = require('gulp-concat'),
    uglify        = require('gulp-uglify'),

    plumber       = require('gulp-plumber'),
    debug         = require('gulp-debug'),
    notify        = require("gulp-notify");




/*------------------------------------*\
 Uglify
\*------------------------------------*/

gulp.task('compress', function() {
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

// gulp.task('compile-coffee', function() {
//     gulp.src('resources/assets/js/**/*.coffee')
//         .pipe(sourcemaps.init())
//         .pipe(coffee({bare: true}).on('error', gutil.log))
//         .pipe(sourcemaps.write())
//         .pipe(plumber())
//         .pipe(concat('app.js'))
//         .pipe(debug({title: 'compile-coffee:'}))
//         .pipe(gulp.dest('public/build/js'));
// });


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
    // 'copy-theme-libs',
    // 'copy-theme-fonts',
    // 'sass',
    'compress',
    // 'compile-coffee',
    'watch'
]);

/*------------------------------------*\
 Watch
\*------------------------------------*/

gulp.task('watch', function() {
    // gulp.watch('resources/assets/sass/**/*.scss', { interval: 500 }, ['sass', 'notify']);
    // gulp.watch('resources/assets/js/**/*.coffee', ['compile-coffee', 'notify']);
});



/**
 ***************************************************************
 * =FUNCTIONS
 ***************************************************************
 **/

// function like a plumber js
function error(error) {
    console.log(error.toString());
    this.emit('end');
}