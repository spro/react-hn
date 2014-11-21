_ = require 'underscore'
polar = require 'polar'
request = require 'request'
hashpipe = require 'hashpipe'
pipeline = new hashpipe.Pipeline()
    .use('http')
    .set('vars', 'hnapi', 'https://hacker-news.firebaseio.com/v0')

css_compiler = require './compilers/css'
js_compiler = require './compilers/js'
jsx_renderer = require './renderers/jsx'

app = polar.setup_app
    port: 5682
    middleware: [css_compiler, js_compiler, jsx_renderer]

app.get '/', (req, res) ->
    res.render 'base'

cached = {}

pipeline_route = (method, url, script) ->
    app[method] url, (req, res) ->
        return res.json cached[req.url] if cached[req.url]?
        inp = _.extend {}, req.params, req.query
        pipeline.exec script, inp, (err, result) ->
            console.log '[ERROR] ' + err if err?
            cached[req.url] = result
            res.json result

pipeline_route 'get', '/posts.json', '''
get $hnapi/topstories.json | head 10
    || get $( key $hnapi /item/ $! .json )
'''

pipeline_route 'get', '/comments.json', '''
@ids | split ','
    || get $( key $hnapi /item/ $! .json )
    | filter "!i.deleted"
'''

app.start()

