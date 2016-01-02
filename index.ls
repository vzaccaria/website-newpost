{docopt} = require('docopt')
require! \lodash
require! \moment
require! 'fs'
$  = require('string')
__ = require('bluebird')
co = require('co')

shelljs = require('shelljs')

doc = shelljs.cat(__dirname+"/docs/usage.md")

exec = __.promisify(shelljs.exec)

get-option = (a, b, def, o) ->
    if not o[a] and not o[b]
        return def
    else
        return o[b]

get-options = ->

    o         = docopt(doc)
    edit      = o['edit']
    publish   = o['publish']
    file      = o['FILE']
    title     = o['TITLE']
    category  = get-option('-c' , '--category', 'infob'  , o)

    return { edit, title, category, publish, file }

main = ->*
    { title, category, edit, file } = get-options!
    if edit
        filename = "#{$(title.toLowerCase()).dasherize()}.md"
        name = moment().format("YYYY-MM-DD") + "-#filename"
        content = """
        ---
        title: #title
        date: #{moment().format('YYYY-MM-DD')}

        layout: post
        category : #category
        tags : ['']
        ---
        """
        year = moment().format('YYYY')
        month = moment().format('MM')
        day = moment().format('DD')

        yield exec("mkdir -p _drafts")
        content.to("_drafts/#name")

        commands = [
            exec "open _drafts/#name -a 'MacDown'"
        ]
        yield commands
    else
      commands = [
            exec "cp #file _posts"
            exec "git add _posts"
            exec "git commit -m 'publish post'"
      ]
      yield commands





co(main).then ->
    console.log "done."
