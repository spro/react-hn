moment = require 'moment'
React = require 'react'
PostsDispatcher = require '../dispatchers/posts'

showTime = (t) -> moment(t*1000).fromNow()

Posts = React.createClass
    getInitialState: ->
        posts: []

    componentWillMount: ->
        PostsDispatcher.getPosts (err, posts) =>
            @setState {posts}

    render: ->
        <div>{@state.posts.map (p) -> <Post post={p} />}</div>

Post = React.createClass
    getInitialState: ->
        open: false
        loading: false

    toggleComments: ->
        if !@state.open && !@state.comments
            @loadComments()
        else
            @setState open: !@state.open

    loadComments: ->
        return if !@props.post.kids

        @setState loading: true
        PostsDispatcher.getComments @props.post.kids, (err, comments) =>
            @setState
                loading: false
                open: true
                comments: comments

    render: ->
        <div className={'post' + (if @state.open then ' open' else '')}>
            <span className='score'>{@props.post.score}</span>
            <p className='title'>{@props.post.title}</p>
            <div className='details'>
                {<span className='n_comments' onClick={@toggleComments}>{@props.post.kids.length}</span> if @props.post.kids?}
                <span className='by'>{@props.post.by}</span>
                <span className='time'>{showTime @props.post.time}</span>
            </div>

            {<div className='comments'>{@state.comments.map (c) -> <Comment comment={c} />}</div> if @state.open}
            {<div className='comments loading'>Loading comments...</div> if @state.loading}
        </div>

Comment = React.createClass
    getInitialState: ->
        open: false
        loading: false

    loadComments: ->
        return if !@props.comment.kids

        @setState loading: true
        PostsDispatcher.getComments @props.comment.kids, (err, comments) =>
            @setState
                loading: false
                open: true
                comments: comments

    render: ->
        <div className={'comment' + (if @state.open then ' open' else '')}>
            <div className='text' dangerouslySetInnerHTML={{__html: @props.comment.text}}></div>
            <div className='details'>
                {<span className='n_comments' onClick={@loadComments}>{@props.comment.kids.length}</span> if @props.comment.kids?}
                <span className='by'>{@props.comment.by}</span>
                <span className='time'>{showTime @props.comment.time}</span>
            </div>

            {<div className='comments'>{@state.comments.map (c) -> <Comment comment={c} />}</div> if @state.open}
            {<div className='comments loading'>Loading comments...</div> if @state.loading}
        </div>

module.exports = Posts

