Super simple blogging engine. Follow the rules and it should be fun.

* put your blog posts in a folder called "posts"
* use the `.md` file extension
* put your metadata at the top like I did it

It looks like this:

    title: title of your blog post
    date: 2012-12-01
    time: 8:27 AM
    
    and then your blog post goes here, with markdown syntax
    
these are just the ways I like them so that's how I'm making it work.

* edit the `config.rb` file with the name of your blog as well as a subtitle (just leave it as "home" if you're not sure)
* run `bundle install` to make sure you have the necessary gems to run this app
* now you can run `ruby web.rb` and see the site in your browser on port 4567 at <http://localhost:4567>
* or run `shotgun web.rb` and find the site at <http://localhost:9393>
    * shotgun is cool because you can make edits and you won't have to restart the app to see the changes
    * if you don't have it, you may need to `gem install shotgun`
* initialize a git repo (`git init`), add all the working files (`git add .`), commit your changes (`git commit -m 'first commit'`)
* create a heroku app (`heroku create yourappname`), push to heroku (`git push heroku master`), and see if it works. if it does you can run `heroku open` to jump right to the site

I mean this blogging engine ***SUCKS*** I just made it really fast and I don't know anything. Take it as is. Hope it serves you well.
