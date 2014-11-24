React = require 'react'
Hammer = require 'hammerjs'

PostsDispatcher = require '../dispatchers/posts'
Comment = require './comment'
{showTime} = require '../helpers'

Post = React.createClass
    getInitialState: ->
        open: false
        loading: false
        color: 'black'

    componentDidMount: ->
        @hammer = Hammer(@getDOMNode())
        @hammer.on 'swipe', @handleSwipe
        @hammer.on 'doubletap', @toggleComments

    handleSwipe: (e) ->
        console.log "swiped on #{ @props.post.title }", e
        if e.direction == 2 # Left
            PostsDispatcher.hidePost @props.post
        if e.direction == 4 # Right
            @setState color: 'green'

    toggleComments: (e) ->
        e?.preventDefault()

        if !@state.open && !@state.comments
            @loadComments()
        else
            @setState open: !@state.open

    loadComments: ->
        return if !@props.post.kids
        return @setState open: false if @state.open

        @setState loading: true
        PostsDispatcher.fetchComments @props.post.kids, (err, comments) =>
            @setState
                loading: false
                open: true
                comments: comments

    openArticle: ->
        window.open @props.post.url

    render: ->
        <div className={'post' + (if @state.open then ' open' else '')} style={{backgroundColor: @state.color}}>
            <span className='score'>{@props.post.score}</span>
            <a className='title' onClick={@openArticle}>{@props.post.title}</a>
            <div className='details'>
                {<a className='n_comments' onClick={@toggleComments}>{@props.post.kids.length}</a> if @props.post.kids?}
                <span className='by'>{@props.post.by}</span>
                <span className='time'>{showTime @props.post.time}</span>
            </div>

            {<div className='comments'>{@state.comments.map (c) -> <Comment comment={c} key={c.id} />}</div> if @state.open}
            {<div className='comments loading'>Loading comments...</div> if @state.loading}
        </div>

module.exports = Post

