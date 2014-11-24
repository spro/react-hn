React = require 'react/addons'
PostsStore = require '../stores/posts'
PostsDispatcher = require '../dispatchers/posts'
Post = require './post'

Posts = React.createClass
    getInitialState: ->
        loading: true

    getStoredState: ->
        posts: PostsStore.posts
        loading: !PostsStore.posts?

    setStoredState: (cb) ->
        @setState @getStoredState(), cb

    componentDidMount: ->
        PostsDispatcher.on 'update', @setStoredState
        @setStoredState =>
            if !@state.posts?
                PostsDispatcher.fetchPosts()

    render: ->
        if @state.posts
            posts = @state.posts.map (p) ->
                <Post post={p} key={p.id} />
            posts = <React.addons.CSSTransitionGroup transitionName="slideAway">{posts}</React.addons.CSSTransitionGroup>

        <div>
            {posts}
            {<div className='loading'>Loading posts...</div> if @state.loading}
        </div>

module.exports = Posts

