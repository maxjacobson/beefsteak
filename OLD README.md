# beefsteak

**update: 2013-03-18**: okay, I'm going to try to make this thing a little better now.

**update: 2012-12-22**: *added some support for pinboard which breaks some stuff mostly pagination? Maybe? I don't feel like testing it right now*

A simple blog on a simple blogging engine. Mine is online currently at <http://www.maxjacobson.net>.

Just replace the contents of the `/posts` folder with your posts and the `config.rb` file with your info, and it should work.

Same with the `/posts` folder.

* make sure you have ruby, rubygems, and bundler
* run `bundle install` to get the necessary gems
* now you can run `ruby web.rb` and see the site in your browser on port 4567 at <http://localhost:4567>
* or run `shotgun web.rb` and find the site at <http://localhost:9393>

That's to run it locally. If you want to put it online install the heroku toolchain and put it on there. You'll need to know how to use git for that.

## license

The MIT License (MIT)

Copyright (c) 2013 Max Jacobson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## todos and notes to self

- [ ] actually display posts on the home page, and the list on an archive page. maybe just the first x posts, and then archive
- [ ] remove pagination
- [ ] add pinboard search
- [ ] should the pages include a tilde? could just combine the ~ get into the `get /*` and first check if the file exists in `/posts` and if so, make a post, then check if it exists in `/pages` and if so make a page... hrm
- [ ] if the date for something is in the future, don't show it until then
- [x] maybe include public pinboard links ala a link blog?
- [ ] maybe adapt for use as a podcast host / feed generator? Or add an option to include that? I can feel my butthole tightening as I consider those complications
- [x] consider amending the HTML head to refer to the secondary feeds when on category/tag/search pages
- [ ] allow single quotes in search not just double quotes
- [ ] sort search results by relevance, maybe include a little snippet that matches???
- [ ] should search also check pages? probably not, right? just checking posts is probably fine
- [ ] feeds for search queries... seem to ignore quoted queries. is that cool? consider fixing that
