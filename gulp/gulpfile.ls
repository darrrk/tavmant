# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
tavmant = require "../common.ls" .call!


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
del = require "del"
image_min = require "gulp-imagemin"
minify_css = require "gulp-minify-css"
minify_html = require "gulp-htmlmin"
run_sequence = require "run-sequence"
static_server = require "node-static"
uglify = require "gulp-uglify"
useref = require "gulp-useref"


# ******************
#    LOCAL SERVER
# ******************
server = null
up_server = (dir, cb)->
    file = new static_server.Server dir
    <- (next)-> server?close next or next!
    server := require "http" .create-server (req, res)->
        req.add-listener "end", -> file.serve req, res
        .resume!
    .listen 9000, ->
        tavmant.radio.trigger "logs:new", "Сервер поднят по адресу http://localhost:9000"
        cb!


# ***************
#    BUILD DEV
# ***************
gulp.task "очистка", ->
    del ["#{tavmant.path}/@dev/**/*.*", "#{tavmant.path}/@prod/**/*.*"], force: true

gulp.task "cбор данных", (cb)->
    tavmant.stores.database_store.get_data_from_fs cb

gulp.task "построение HTML", ["cбор данных"], (cb)->
    HTML_Build = require "./build_html.ls"
    html_builder = new HTML_Build
    html_builder.start cb

gulp.task "резка изображений", (cb)->
    Resize_Images = require "./resize_images.ls"
    resize_images = new Resize_Images
    resize_images.start cb

gulp.task "копирование CSS JS", ->
    gulp.src [
        "#{tavmant.path}/assets/**/*.js"
        "#{tavmant.path}/assets/**/*.css"
    ]
    .pipe gulp.dest "#{tavmant.path}/@dev/"

gulp.task "копирование изображений и других бинарных файлов", ->
    gulp.src [
        "#{tavmant.path}/assets/**/*"
        "!#{tavmant.path}/assets/**/*.js"
        "!#{tavmant.path}/assets/**/*.css"
    ].concat if tavmant.stores.settings_store.attributes.resize_images
        _.map tavmant.stores.settings_store.attributes.resize_images.paths, (pth)->
            "!#{tavmant.path}/#{pth}/**/*.jpg"
    else
        []
    .pipe gulp.dest "#{tavmant.path}/@dev/"

gulp.task "базовая сборка", ["очистка"], (cb)->
    run_sequence do
        [
            "построение HTML"
            "копирование изображений и других бинарных файлов"
            "копирование CSS JS"
        ].concat if tavmant.stores.settings_store.attributes.resize_images then "резка изображений" else []
        cb

gulp.task "сервер", ["базовая сборка"], (cb)->
    <- up_server "#{tavmant.path}/@dev"
    <- require <| "./livereload.ls"
    cb!


# *****************
#    PRODUCTION
# *****************
gulp.task "копирование шрифтов", ->
    gulp.src "#{tavmant.path}/@dev/font/**/*.*"
    .pipe gulp.dest "#{tavmant.path}/@prod/font"

gulp.task "копирование файлов в корень сайта", ->
    gulp.src "#{tavmant.path}/site_root/**/*"
    .pipe gulp.dest "#{tavmant.path}/@prod"

gulp.task "сжатие изображений", ->
    gulp.src [
        "#{tavmant.path}/@dev/**/*.jpg"
        "#{tavmant.path}/@dev/**/*.jpeg"
        "#{tavmant.path}/@dev/**/*.png"
        "#{tavmant.path}/@dev/**/*.gif"
        "#{tavmant.path}/@dev/**/*.svg"
        "!#{tavmant.path}/@dev/font/**/*.svg"
    ]
    .pipe image_min()
    .pipe gulp.dest "#{tavmant.path}/@prod"

gulp.task "объединение CSS JS", ->
    assets = useref.assets()
    gulp.src "#{tavmant.path}/@dev/**/*.html"
    .pipe assets
    .pipe assets.restore()
    .pipe useref()
    .pipe gulp.dest "#{tavmant.path}/@prod"

gulp.task "сжатие HTML", ["объединение CSS JS"], ->
    gulp.src "#{tavmant.path}/@prod/**/*.html"
    .pipe minify_html do
        collapseWhitespace : true
        removeComments     : true
    .pipe gulp.dest "#{tavmant.path}/@prod"

minify_js_css = !(type, cb)->
    try_resolve = _.after 2, cb
    if type is "js"
        minificator = uglify
    else if type is "css"
        minificator = minify_css

    gulp.src "#{tavmant.path}/@prod/**/*.#type"
    .pipe minificator()
    .pipe gulp.dest "#{tavmant.path}/@prod"
    .on "finish", try_resolve

    gulp.src "#{tavmant.path}/@dev/#type/custom/**/*.#type"
    .pipe minificator()
    .pipe gulp.dest "#{tavmant.path}/@prod/#type/custom"
    .on "finish", try_resolve

gulp.task "сжатие JS", ["объединение CSS JS"], (cb)->
    minify_js_css "js", cb

gulp.task "сжатие CSS", ["объединение CSS JS"], (cb)->
    minify_js_css "css", cb

gulp.task "боевая сборка", ["базовая сборка"], (cb)->
    run_sequence [
        "сжатие изображений"
        "сжатие HTML"
        "сжатие CSS"
        "сжатие JS"
        "копирование шрифтов"
        "копирование файлов в корень сайта"
    ], ->
        up_server "#{tavmant.path}/@prod", cb


# **********************
#    DEFAULT DEV SITE
# **********************
gulp.task "сборка для разработчика", ["сервер"]


# ******************
#    RUN PACKAGED
# ******************
# from gulp 3.9.0
gutil = require "gulp-util"
prettyTime = require "pretty-hrtime"

logEvents = (gulpInst)->

  # Total hack due to poor error management in orchestrator
  gulpInst.on "err", ->
    failed = true

  gulpInst.on "task_start", (e)->
    # TODO: batch these
    # so when 5 tasks start at once it only logs one time with all 5
    tavmant.radio.trigger "logs:new",
      "Стартовало \'" + e.task + "\'..."

  gulpInst.on "task_stop", (e)->
    time = prettyTime(e.hrDuration)
    tavmant.radio.trigger "logs:new",
      "Завершилось \'" + e.task + "\' после " + time

  gulpInst.on "task_err", (e)->
    time = prettyTime(e.hrDuration)
    tavmant.radio.trigger "logs:new:err",
      "'#{e.task}' завершилось с ошибкой #{e.err.message or e.err} после #{time}"

  gulpInst.on "task_not_found", (err)->
    tavmant.radio.trigger "logs:new",
      "Задача \'" + err.task + "\' отсутствует"

logEvents gulp
