require 'sinatra'
require 'kramdown'
# Kramdown::Document.new(text).to_html

get '/' do
  config = {
    :domain => "http://devblog.maxjacobson.net"
  }
  @title = "devblog - max jacobson"
  the_html = String.new
  the_html << "<h1>#{@title}</h1>\n\n<hr />"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      the_text = File.read("posts/" + filename)
      the_html << Kramdown::Document.new(the_text).to_html + "<hr />"
    end
  end
  erb the_html
end

get '/css/style.css' do
  scss :style
end