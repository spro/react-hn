storage =
    set: (k, o) ->
        localStorage.setItem(k, JSON.stringify o)
    get: (k) ->
        v = localStorage.getItem(k)
        JSON.parse(v) if v

PostsStore =
    hidden_ids: storage.get('hidden_ids') || []

    filterHidden: (posts) ->
        posts.filter (p) => p.id not in @hidden_ids

    save: ->
        storage.set 'hidden_ids', @hidden_ids

module.exports = PostsStore

