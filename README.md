# beefsteak

small blog platform for people who, like me,

* use pinboard public links as a kind of link blog
* blog infrequently
* like markdown and use the `.md` file extension
* write your dates like this: 2013-03-18

Mine is online at <http://www.maxjacobson.net>

## steps:

* clone the repo
* edit the `beef_config.rb` file with your info
* add some `.md` files to `/posts` and `/pages`
* if you want to run it locally
    * `bundle install`
    * `shotgun web.rb`
    * go to <http://localhost:9393>
* commit and push to heroku

## todos and notes to self

I just rewrote the whole thing and some features need to be re-implemented still.

- [ ] add post search (allow single or double quotes for quoted queries)
- [ ] add pinboard search
- [ ] if the date for something is in the future, don't show it until then
- [ ] add post feed
- [ ] re-implement tag and category pages'
- [ ] add tag and category clouds
- [ ] add category and tag feeds, and put them in the head as secondary feeds
- [ ] add analytics
- [ ] make sure responsive design is good

## if you're working on the site

* if editing the coffeescript, this is a helpful command: `coffee -j public/js/app.js -cw assets/coffee/`
* if editing the SASS: `compass watch`

## license

The MIT License (MIT)

Copyright (c) 2013 Max Jacobson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
