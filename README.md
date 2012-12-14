# beefsteak

A simple blog on a simple blogging engine. Mine is online currently at <http://devblog.maxjacobson.net> and I guess it'll probably stay there.

Just replace the contents of the `/posts` folder with your posts and the `config.rb` file with your info, and it should work.

* make sure you have ruby, rubygems, and bundler
* run `bundle install` to get the necessary gems
* now you can run `ruby web.rb` and see the site in your browser on port 4567 at <http://localhost:4567>
* or run `shotgun web.rb` and find the site at <http://localhost:9393>

That's to run it locally. If you want to put it online install the heroku toolchain and put it on there. You'll need to know how to use git for that.

## license or whatever

Do whatever you want. It's as-is, etc.

## todos?

* be consistent re: the trailing slash... for posts its there but not for tag pages. hrm.
* if the date for something is in the future, don't show it