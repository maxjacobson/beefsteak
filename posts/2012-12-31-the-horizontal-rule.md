title: the horizontal rule
date: 2012-12-31
time: 4:29 AM
category: the internet
tags: youre doing it wrong

On a sexier and perhaps better blog, this post title would be a euphemism.

Instead, this post is a bit of a follow up to [an earlier post][], so this second entry might as well mark the beginning of a series.

[an earlier post]: http://www.maxjacobson.net/2012-03-21-indenting-paragraphs-online

***It's time for [You're doing it wrong][]!***, the yearly column where I criticize people's blog's CSS even though I'm not an authority on that subject![^1]

[^1]: I'm inspired in part by the dear, departed podcast [Hypercritical](http://5by5.tv/hypercritical), which good-naturedly criticized all kinds of stuff with the hopes that things might improve! I miss that show! [This drawing](http://davidgalletly.com/blog/2012/11/21/hypercritical-ends.html) is sweet as hell.

[You're doing it wrong]: http://www.maxjacobson.net/tag/youre-doing-it-wrong

Let's talk about lines.

There aren't that many HTML tags, and markdown only supports the small subset that are relevant to writers. So let's make use of them.

There are a few ways to make an `<hr />` in markdown. I tend to write `* * *` but it's flexible. You could use hyphens instead if you like and space them out if you like.

In HTML, the horizontal rule looks like this: `<hr />`. On this blog, in a browser, at this time of writing, it looks like two thin lines on top of one another. The css I used for that looks like this:

    hr {
      padding: 0;
      border: none;
      border-top: medium double #333;
    }

CSS is really flexible. You can even replace an `<hr />` with an image. The blog post that I'm constantly googling for is [this one][] by Marek Prokop which gives a great introduction to the different ways you can style `<hr />`s. Heres [another](http://css-tricks.com/examples/hrs/), from which I more or less cribbed their last example.

[this one]: http://www.tizag.com/htmlT/htmlhr.php

Considering how good `<hr />`s are, I don't understand why bloggers like [Shawn Blanc][] and [Stephen Hackett][] (whom I generally like), don't use them.

[Shawn Blanc]: http://shawnblanc.net/2012/12/inbox-intentions/
[Stephen Hackett]: http://shawnblanc.net/2012/12/inbox-intentions/

They get the appeal of a nice separating line but instead of using an `<hr />`, which is easy to make with markdown, which I think they both use, they do this:

    <div align="center">* * *</div>

or:

    <p style="text-align:center">* * *</p>

Both commit the cardinal sin of embedding CSS in the middle of an HTML tag. You're not supposed to do that! Even if you don't want to use an `<hr />`, the correct move would be to [separate content and presentation][] by assigning a class and then selecting that class with the CSS, like so:

The HTML:

    <div class="separator">* * *</div>

The CSS:

    .separator {
      align: center;
    }

[separate content and presentation]: http://en.wikipedia.org/wiki/Separation_of_presentation_and_content

I *assume* they do it this way with the hope that it will be more portable. These days, people often read blog posts in their RSS reader, far out of reach of their blog's CSS. In these contexts, the post is subject to the reader app's CSS, and a div with a class will be treated as unstyled text, but a div with inline CSS might still be styled.

Sometimes.

If I'm reading a post outside of a browser, it's probably in Reeder or Instapaper (links unnecessary, right?). In Reeder, the rat tactic works and the stars are centered and more or less convey what the authors want them to. In Instapaper, the CSS is totally overridden and [it's just a couple of asterisks][]. Same for Safari Reader, Readability, probably others.

[it's just a couple of asterisks]: http://d.pr/i/yP1Y

Had they used an `<hr />`, each individual reader would style it as they see fit, but they would understand what it is and work to convey your meaning.

Besides, it's not that [semantic][] is it?

Blanc's p tag is most egregious in this regard, because p means *paragraph*, which this is not. It may have been chosen because the blog's CSS properties for paragraphs *also* applied to separators, but that does not make this a paragraph.

[semantic]: http://stackoverflow.com/questions/1294493/what-does-semantically-correct-mean

* * *

Here's the rub: as flexible as CSS is, I have no idea how to style an `<hr />` so that it looks the way these guys seem to want it to look without embedding a small image at every `<hr />`, which introduces its own set of problems.

* According to [Prokop][], an image `<hr />` has visual bugs in IE and Opera, so he resorts to a bit of a hack, namely wrapping the `<hr />` in a div with some additional rules, which is a bit of a nonstarter for markdown users -- we need something that automatically expands from `* * *` and looks right.
* I've tried this in the past and it looked kind of lo-res and not great on a retina display

[Prokop]: www.tizag.com/htmlT/htmlhr.php

I think these problems are surmountable by:

1. just ignoring those browsers
2. researching hi-res images and how to do it right (on my to do list)

So what would that look like?

The HTML:

    <hr />

The CSS:

    hr {
      height: 13px;
      background: url(hr.png) no-repeat scroll center;
      border: 0;
    }

The image could be anything but [here's one][] I just whipped up in pixelmator with a transparent background to play nice with various sites. Keep in mind: the height property corresponds to the image's height, so if you use a different image, adjust accordingly.

[here's one]: http://d.pr/i/AoSz

This opens you up to use actual stars instead of asterisks! I call that an upgrade. And if you turn CSS off or Instapaper it, it degrades nicely to a plain old horizontal rule, which isn't really so bad. It's good enough for [John Gruber][] anyway, who writes simply `<hr>` without the closing slash that I think is a relatively recent convention. His rule looks like three pale centered dots and doesn't use an image.

His CSS:

    hr {
      height: 1px;
      margin: 2em 1em 4em 0;
      text-align: center;
      border-color: #777;
      border-width: 0;
      border-style: dotted;
      }

[John Gruber]: http://daringfireball.net/2012/12/google_maps_iphone

I don't really understand how that becomes three pale dots but then I don't really know anything about CSS.
