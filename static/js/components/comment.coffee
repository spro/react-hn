React = require 'react'
PostsDispatcher = require '../dispatchers/posts'
{showTime} = require '../helpers'

Comment = React.createClass
    getInitialState: ->
        open: false
        loading: false

    loadComments: ->
        return if !@props.comment.kids

        return @setState open: false if @state.open

        @setState loading: true
        PostsDispatcher.fetchComments @props.comment.kids, (err, comments) =>
            @setState
                loading: false
                open: true
                comments: comments

    render: ->
        <div className={'comment' + (if @state.open then ' open' else '')}>
            <div className='text' dangerouslySetInnerHTML={{__html: @props.comment.text}}></div>
            <div className='details'>
                {<a className='n_comments' onClick={@loadComments}>{@props.comment.kids.length}</a> if @props.comment.kids?}
                <span className='by'>{@props.comment.by}</span>
                <span className='time'>{showTime @props.comment.time}</span>
            </div>

            {<div className='comments'>{@state.comments.map (c) -> <Comment comment={c} />}</div> if @state.open}
            {<div className='comments loading'>Loading replies...</div> if @state.loading}
        </div>

module.exports = Comment

