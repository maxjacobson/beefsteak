title: going open source
date: 2012-12-02
time: 9:58 PM
category: coding
tags: devblog, github, open source, san diego

Just for fun I'm sharing [the source code for this blog in full on github](https://github.com/maxjacobson/beefsteak). I don't know if anyone else will or should use this but maybe they'll want to.

It's surprisingly easy having two remote destinations for this code (heroku, where my blog is hosted, and now github where the source code is hosted). I make changes, commit them, push to one, then push to the other. Easy peasy.

If someone else wants to use it, they'll have to delete my stuff and replace it with their stuff. I'm not giving them a blank slate. Because I'm not sure how to maintain two separate versions like that. But they'll figure it out, I think.

I guess I've been planning to do this, because I've refrained from hardcoding my information (name, blog title, etc) into the code. Instead it's in a separate `config.rb` file (which you can [see on github](https://github.com/maxjacobson/beefsteak/blob/master/config.rb)).

I'm cold on this balcony in San Diego. I am proud that I made this in like two days. I will keep working on it.