# our front end code

This is all jQuery, so we're going to invoke the jQuery method with `$` and send the rest of the code to it. I *think* this will just make it wait for the page to load before doing anything.

    $ ->


## plugins

I want to use [this plugin](http://css-tricks.com/fluid-width-youtube-videos/) but it's in js, so I've adapted it to CoffeeScript and made it work with all iframes, not just youtube ones. dope plugin chris!

      $allVideos = $("iframe")
      $fluidEl = $("body")
      $allVideos.each ->
        $(this).data('aspectRatio', this.height / this.width).removeAttr('height').removeAttr('width')
      $(window).resize ->
        newWidth = $fluidEl.width()
        $allVideos.each ->
          $el = $(this)
          $el.width(newWidth).height(newWidth * $el.data('aspectRatio'))
      $(window).resize()

## syntax highlighting

Lets add the "prettyprint" class to all pre objects so that they'll have syntax highlighting. I guess normally you'd hardcode this into the HTML but because I'm generating all my HTML from markdown, I can't. So I'm doing it first thing on page load.

      $("pre").addClass "prettyprint"

## hot tags

OK, so now let's worry about our hot tags. This is only relevant to our home page with the pinboard links but right now this code gets run on every page, which, you know, oh well.

On that page I have a hidden list of hot tags with the id of "hot_tag". So I'm getting that list and putting it into an array.

      hot_tags = []
      $("li#hot_tag").each -> hot_tags.push $(this).text()

THEN, I'm checking every single pinboard tag on the page and if it's a hot tag, I'm making its parent pinboard item "super_hot" which my CSS can target.

      $(".pin-tag").each -> $(this).parents(".pin-item").addClass "super_hot" if $(this).text() in hot_tags


## footnotes

Whenever you click on a footnote, which is a tiny little number, we take note of what that number is and find its corresponding footnote text and tell it to get our attention.

      $(".footnote").on "click", ->
        num = parseInt $(this).text()
        $(".footnotes li").eq(num-1).anim "attention"

Then, when you click the little return button we take note of the URL that was clicked on...

      $(".reversefootnote").on "click", ->
        footnote = $(this).attr("href").replace(/fnref/, 'fn')

And check *every* footnote to see if it matches that, and then make the whole section it's in wiggle randomly.

        $("a.footnote").each ->
          source = $(this).attr "href"
          $(this).parent().parent().anim "attention" if footnote is source
