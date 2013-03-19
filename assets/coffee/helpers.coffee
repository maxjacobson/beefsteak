puts = (str) -> console.log str
delay = (s, func) -> setTimeout func, s*1000
$.fn.anim = (anim) ->
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
    "lightSpeedOut", "rollOut"
  ]
  animations = [
    "flash", "bounce", "shake", "tada", "swing", "wobble", "wiggle", "pulse", "hinge"
  ]
  if anim is "random"
    index = Math.floor Math.random()*animations.length
    anim = animations[index]
  else if anim is "enter"
    index = Math.floor Math.random()*entrances.length
    anim = entrances[index]
  else if anim is "exit"
    index = Math.floor Math.random()*exits.length
    anim = exits[index]
  puts "animating #{anim}"
  blob = this
  blob.addClass "animated #{anim}"
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
  delay speed, -> blob.removeClass "animated #{anim}"