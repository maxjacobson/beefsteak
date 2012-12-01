require 'sinatra'
require 'kramdown'
require_relative 'config'

get '/' do
  @title = get_title
  @subtitle = get_subtitle
  the_html = String.new
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      the_html << Kramdown::Document.new(the_text).to_html + "\n"
      the_html << "<a href=\"#{naked_filename}/\">Permalink</a><hr />\n"
    end
  end
  erb the_html
end

get '/*/' do
  the_html = String.new
  naked_filename = params[:splat][0].to_s
  the_text = File.read("posts/" + naked_filename + ".md")
  the_html << Kramdown::Document.new(the_text).to_html
  the_html << "<a href=\"/#{naked_filename}.md\">Markdown source</a>\n<hr />\n"
  @title = get_title
  @subtitle = naked_filename
  erb the_html
end

get '/*.md' do
  filename = "posts/" + params[:splat][0].to_s + ".md"
  naked_filename = params[:splat][0].to_s
  the_text = File.read(filename)
  the_text.gsub!(/</, '&lt;')
  the_text.gsub!(/>/,'&gt;')
  @title = get_title
  @subtitle = "markdown source of " + naked_filename
  erb "<h2>Markdown source of <a href=\"#{naked_filename}/\">#{params[:splat][0].to_s + ".md"}</a></h2>\n\n<pre>\n" + the_text + "\n</pre>"
end

get '/css/style.css' do
  scss :style
end