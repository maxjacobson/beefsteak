require 'sinatra'
require 'kramdown'

get '/' do
  @title = "devblog - max jacobson"
  the_html = String.new
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      the_html << "<a href=\"#{filename}\">#{filename}</a>"
      the_text = File.read("posts/" + filename)
      the_html << Kramdown::Document.new(the_text).to_html + "<hr />"
    end
  end
  erb the_html
end

get '/*.md' do
  @title = "devblog - max jacobson"
  the_text = File.read("posts/" + params[:splat][0].to_s + ".md")
  erb Kramdown::Document.new(the_text).to_html
end

get '/css/style.css' do
  scss :style
end