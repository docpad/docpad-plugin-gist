module.exports = (BasePlugin) ->

    class GistPlugin extends BasePlugin
        name: 'gist'

        getGist = (opts, next) ->
            {content} = opts

            gists = content.match(/<gist>.+<\/gist>/g)

            for gist in gists
                gistScript = gist.replace(/<gist>/g,"<script src='https://gist.github.com/")
                if gistScript.indexOf('.js') != -1
                    gistScript = gistScript.replace(/<\/gist>/g,"'></script>")
                else
                    gistScript = gistScript.replace(/<\/gist>/g,".js'></script>")

                content = content.replace(gist, gistScript)

            opts.content = content

            return next()

        renderDocument: (opts, next) ->
            {extension, file} = opts
            if file.type is 'document' and extension is 'html'
                getGist opts,next
            else
                return next()
