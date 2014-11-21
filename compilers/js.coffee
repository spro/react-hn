browserify = require 'browserify'
coffee_reactify = require 'coffee-reactify'
React = require 'react'
require('node-cjsx').transform()

# TODO: Smart way to import all necessary components

# Rendering
# ------------------------------------------------------------------------------

# Render a full response
render = (res, component, props) ->
    content = renderComponent component, props
    content += renderBootstrap props
    res.render 'index', {content}

# Render a bootstrap script tag
renderBootstrap = (props) ->
    bootstrap = "window.bootstrap = #{ JSON.stringify(props) };"
    "<script type='text/javascript'>#{ bootstrap }</script>"

# Render a component to HTML
renderComponent = (component, props) ->
    delete require.cache[require.resolve './static/components/' + component]
    _Component = require './static/components/' + component
    React.renderToString React.createFactory(_Component)(props)

js_dir = './static/js'
module.exports = (req, res, next) ->

    if matched = req.url.match '/js(/.+)\.js'
        coffee_filename = js_dir + matched[1] + '.coffee'
        console.log '[JS Compiler] Going to compile ' + coffee_filename
        try
            bundler = browserify(extensions: ['.coffee', '.cjsx'])
            bundler.transform coffee_reactify
            bundler.add(coffee_filename).bundle().pipe(res)
        catch e
            res.end e.toString()
            
    else
        next()

