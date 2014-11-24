$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
PostsStore = require '../stores/posts'

PostsDispatcher = _.extend {}, Backbone.Events,

    fetchPosts: ->
        $.get '/posts.json', (posts) ->
            PostsStore.posts = PostsStore.filterHidden posts
            PostsDispatcher.trigger 'update'

    hidePost: (post) ->
        console.log 'hiding post', post
        PostsStore.hidden_ids.push post.id
        PostsStore.posts = PostsStore.filterHidden PostsStore.posts
        PostsStore.save()
        PostsDispatcher.trigger 'update'

    fetchComments: (comment_ids, cb) ->
        ids = comment_ids.join(',')
        $.get '/comments.json?ids='+ids, (comments) ->
            cb null, comments

module.exports = PostsDispatcher

