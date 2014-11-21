browserify = require 'browserify'
coffee_reactify = require 'coffee-reactify'
React = require 'react'
require('node-cjsx').transform()

# Rendering
# ------------------------------------------------------------------------------

# Render a full response
render = (res, component, props) ->
    content = renderComponent component, props
    content += renderBootstrap props
    res.render 'base', {content}

# Render a bootstrap script tag
renderBootstrap = (props) ->
    bootstrap = "window.bootstrap = #{ JSON.stringify(props) };"
    "<script type='text/javascript'>#{ bootstrap }</script>"

# Render a component to HTML
renderComponent = (component, props) ->
    delete require.cache[require.resolve '../static/js/components/app-view']
    _AppView = require '../static/js/components/app-view'
    React.renderToString React.createFactory(_AppView)(page_view: component, page_props: props)

# Attach the renderer to res

module.exports = (req, res, next) ->
    res.render_jsx = render.bind null, res
    next()

