$ = require 'jquery'

PostsDispatcher =

    getPosts: (cb) ->
        $.get '/posts.json', (posts) ->
            cb null, posts

    getComments: (comment_ids, cb) ->
        ids = comment_ids.join(',')
        $.get '/comments.json?ids='+ids, (comments) ->
            cb null, comments

module.exports = PostsDispatcher

