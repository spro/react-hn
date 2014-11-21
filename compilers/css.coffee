fs = require 'fs'
styl = require 'styl'
rework_color = require 'rework-color-function'
rework_colors = require 'rework-plugin-colors'
rework_variant = require 'rework-variant'
rework_shade = require 'rework-shade'
rework_import = require 'rework-import'

vars =
    red: '#a03731'
    green: '#558c45'
    blue: '#287aa2'

    small: '13px'
    normal: '14px'
    medium: '16px'
    large: '20px'
    huge: '24px'

css_dir = './static/css'
module.exports = (req, res, next) ->

    if matched = req.url.match '/css(/.+)\.css'
        sass_filename = css_dir + matched[1] + '.sass'
        console.log '[CSS Compiler] Going to compile ' + sass_filename

        variant = rework_variant(vars)
        transformer = (sass_src) ->
            styl(sass_src, {whitespace: true})
                .use(rework_import({path: css_dir, transform: transformer}))
                .use(variant) # For variable replacement
                .use(rework_colors()) # rgba(#xxx, 0.x) transformers
                .use(rework_color) # color tint functions
                .toString()

        sass_src = fs.readFileSync(sass_filename).toString()
        css_src = transformer sass_src
        return res.end css_src

    else
        next()

