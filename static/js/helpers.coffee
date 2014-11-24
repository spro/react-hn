moment = require 'moment'

exports.showTime = (t) -> moment(t*1000).fromNow()

exports.slugify  = (s) -> s.toLowerCase().replace /\W+/g, '-'

# Mixins
# --------------------------------------------------------------------------

exports.StoredStateMixin =

    setStoredState: (cb) ->
        @setState @getStoredState(), cb

