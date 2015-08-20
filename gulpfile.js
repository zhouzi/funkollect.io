var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

gulp.task('styles', function () {
    return gulp
        .src('src/scss/**/*.scss')
        .pipe($.sass({ outputStyle: 'compressed' }))
        .pipe($.autoprefixer())
        .pipe(gulp.dest('public/dist'))
    ;
});

gulp.task('scripts', function () {
    return gulp
        .src([
            'src/app/app.coffee',
            'src/app/storage.coffee',
            'src/app/Product.coffee',
            'src/app/controller.coffee',

            'src/app/views/header-view.coffee',
            'src/app/views/products-view.coffee',
            'src/app/views/owned-blank-view.coffee',
            'src/app/views/need-blank-view.coffee',
            'src/app/views/main-view.coffee',

            'src/app/router.coffee'
        ])
        .pipe($.concat('app.min.js'))
        .pipe($.coffee())
        .pipe($.uglify())
        .pipe(gulp.dest('public/dist'))
    ;
});

gulp.task('images', function () {
    return gulp
        .src('public/images/*.png')
        .pipe($.imagemin())
        .pipe(gulp.dest('public/images'))
    ;
});

gulp.task('watch', ['default'], function () {
    gulp.watch('src/scss/**/*.scss', ['styles']);
    gulp.watch('src/app/**/*.coffee', ['scripts']);
});

gulp.task('default', ['styles', 'scripts']);