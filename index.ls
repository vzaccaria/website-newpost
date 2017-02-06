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
    console.log(get-options!)

    if edit
        filename = "#{$(title.toLowerCase()).dasherize()}.md"
        name = moment().format("YYYY-MM-DD") + "-#filename"
        urlname = "#{$(title.toLowerCase()).dasherize()}.html"
        urldata = moment().format('YYYY/MM/DD')
        urlname = "http://www.vittoriozaccaria.net/\#/#category/#urldata/#urlname"
        content = """
        ---
        title: #title
        date: #{moment().format('YYYY-MM-DD')}

        layout: post
        category : #category
        tags : ['']
        ---

        This post will be available at [this address](#urlname)
        """
        console.log(content)
        year = moment().format('YYYY')
        month = moment().format('MM')
        day = moment().format('DD')

        yield exec("mkdir -p _drafts")
        content.to("_drafts/#name")
        yield exec "open _drafts/#name -a 'MacDown'"
    else
      yield exec "cp #file _posts"
      yield exec "git add _posts/*"
      yield exec "git commit -m 'publish post'"





co(main).then( ,(e) ->
    console.log e)
