$ ->
  delay 0.5, ->
    # $(".yield").toggle()
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
    $(".footnotes li").eq(num-1).anim "random"
  $(".reversefootnote").on "click", ->
    footnote = $(this).attr("href").replace(/fnref/, 'fn')
    $("a.footnote").each ->
      source = $(this).attr "href"
      if footnote is source
        $(this).parent().parent().anim "random"


