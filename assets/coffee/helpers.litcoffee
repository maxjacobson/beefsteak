# some helper methods

Here are some methods I'll be using to help me out in this website.

First, because I am a dumb ruby guy and I sometimes forget where I am, I'm basically remapping `console.log` to ruby's `puts`:

    puts = (str) -> console.log str

This little method helps pause for a set amount of time (in seconds, not the usual milliseconds) before running a function:

    delay = (s, func) -> setTimeout func, s*1000

This is a jQuery plugin for animation using [Dan Eden's CSS3 animations](http://daneden.me/animate):

When we call it, we name the animation we want to use:

    $.fn.anim = (anim) ->

But sometimes we just want a random one. So I broke them into three categories

      entrances = [
        "flipInX", "flipInY", "fadeIn", "fadeInUp", "fadeInDown", "fadeInLeft",
        "fadeInRight", "fadeInUpBig", "fadeInDownBig", "fadeInLeftBig", "fadeInRightBig",
        "bounceIn", "bounceInDown", "bounceInUp", "bounceInLeft", "bounceInRight",
        "lightSpeedIn", "rollIn"
      ]
      exits = [
        "flipOutX", "flipOutY",
        "fadeOut", "fadeOutUp", "fadeOutDown", "fadeOutLeft", "fadeOutRight",
        "fadeOutUpBig", "fadeOutDownBig", "fadeOutLeftBig", "fadeOutRightBig",
        "bounceOut", "bounceOutDown", "bounceOutUp", "bounceOutLeft", "bounceOutRight",
        "lightSpeedOut", "rollOut", "hinge"
      ]
      attentions = [
        "bounce", "shake", "tada", "swing", "wobble", "wiggle", "pulse"
      ]

And pick one at random, overwriting the "anim" variable

      if anim is "attention"
        index = Math.floor Math.random()*attentions.length
        anim = attentions[index]
      else if anim is "enter"
        index = Math.floor Math.random()*entrances.length
        anim = entrances[index]
      else if anim is "exit"
        index = Math.floor Math.random()*exits.length
        anim = exits[index]
      puts "animating #{anim}"

Then I copy the jQuery DOM object into a variable called blob (I can't remember why tbh) and add the class, which triggers the animation.

      blob = this
      blob.addClass "animated #{anim}"

While it's animating let's do one other thing: some of the animations are faster than others, so lets account for that.

      fast = ["fadeOutLeftBig", "fadeOutRightBig", "bounceOutRight", "bounceOutLeft", "bounceOutUp", "bounceOutDown"]
      slow = ["hinge", "bounceOut"]
      if anim in fast
        speed = 0.75
        puts "#{anim} is a fast one"
      else if anim in slow
        speed = 2
        puts "#{anim} is a slow one"
      else
        speed = 1

And after an appropriate delay, we remove the class just to leave things how we found them (and so we can do the animations on the same thing).

      delay speed, -> blob.removeClass "animated #{anim}"
