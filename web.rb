require 'sinatra'
require 'kramdown'
require_relative 'config'
require_relative 'helpers'

get '/' do
  @title = get_title
  @subtitle = get_subtitle
  the_html = String.new
  the_html << "  <ul>\n"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      both = separate_metadata_and_text(the_text)
      body = both[:text]
      meta = both[:metadata]
      the_html << "    <li><a href=\"#{naked_filename}/\">#{meta[:date]} - #{meta[:time]} - #{meta[:title]}</a></li>\n"
    end
  end
  the_html << "  </ul>\n"
  erb the_html
end

get '/*/' do
  the_html = String.new
  naked_filename = params[:splat][0].to_s
  the_text = File.read("posts/" + naked_filename + ".md")
  both = separate_metadata_and_text(the_text)
  body = both[:text]
  meta = both[:metadata]
  the_html << "<h2>#{meta[:title]}</h2>\n"
  the_html << "<h3>Posted on #{meta[:date]} at #{meta[:time]}</h3>"
  the_html << Kramdown::Document.new(body).to_html + "\n"
  the_html << "<a href=\"/#{naked_filename}.md\">Markdown source</a>\n"
  @title = get_title
  @subtitle = meta[:title]
  erb the_html
end

get '/*.md' do
  naked_filename = params[:splat][0].to_s
  filename = "posts/" + naked_filename + ".md"
  the_text = File.read(filename)
  both = separate_metadata_and_text(the_text)
  body = both[:text]
  meta = both[:metadata]
  the_text.gsub!(/</, '&lt;')
  the_text.gsub!(/>/,'&gt;')
  @title = get_title
  @subtitle = "markdown source of " + meta[:title]
  erb "<h2>Markdown source of <a href=\"#{naked_filename}/\">#{meta[:title]}</a></h2>\n\n<pre>\n" + the_text + "\n</pre>"
end

get '/css/style.css' do
  scss :style
end