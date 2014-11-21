$ = require 'jquery'
React = require 'react'
AppView = require './components/app-view'

$ ->
    console.log "Welcome to react hn."
    React.render <AppView />, $('#app')[0]

