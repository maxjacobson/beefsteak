$ ->
  delay 0.5, ->
    $(".yield").toggle()
    $(".yield").anim "enter"
    $(".buffer").slideToggle "slow"
  $("pre").addClass "prettyprint"
  hot_tags = []
  $("li#hot_tag").each -> hot_tags.push $(this).text()
  $(".pin-tag").each ->
    tag = $(this).text()
    $(this).parents(".pin-item").addClass "super_hot" if tag in hot_tags
  $(".footnote").on "click", ->
    num = parseInt $(this).text()
    $(".footnotes li").eq(num-1).anim "bounce"
