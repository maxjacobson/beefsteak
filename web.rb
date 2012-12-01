require 'sinatra'
require 'kramdown'

get '/' do
  @title = "devblog - max jacobson"
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
  @title = "devblog - max jacobson"
  the_html = String.new
  naked_filename = params[:splat][0].to_s
  the_text = File.read("posts/" + naked_filename + ".md")
  the_html << Kramdown::Document.new(the_text).to_html
  the_html << "<a href=\"/#{naked_filename}.md\">Markdown source</a>\n<hr />\n"
  erb the_html
end

get '/*.md' do
  @title = "devblog - max jacobson"
  filename = "posts/" + params[:splat][0].to_s + ".md"
  the_text = File.read(filename)
  the_text.gsub!(/</, '&lt;')
  the_text.gsub!(/>/,'&gt;')
  erb "<h2>Markdown source of #{params[:splat][0].to_s + ".md"}</h2>\n\n<pre>\n" + the_text + "\n</pre>"
end

get '/css/style.css' do
  scss :style
end