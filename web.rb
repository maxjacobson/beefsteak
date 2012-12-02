require 'sinatra'
require 'kramdown'
require_relative 'config'
require_relative 'helpers'

not_found do
  @title= get_title
  @subtitle = "404"
  erb :'404'
end

error do
  @title= "Smash Cut"
  @subtitle = "500"
  erb :'500'
end

get '/' do
  @title = get_title
  @subtitle = get_subtitle
  the_html = String.new
  to_sort = Array.new
  the_html << "  <ul>\n"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename
      to_sort.push(post_info)
    end
  end
  
  to_sort.each do |post|
    the_date = post[:date]
    the_time = post[:time]
    if the_time =~ /AM|am/
      sorter = the_date.gsub(/-/,'') + the_time.gsub(/:| |AM|am/,'')
    end
    if the_time =~ /PM|pm/
      sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
    end
    post[:sorter] = sorter
  end
  to_sort.sort! { |a,b| b[:sorter] <=> a[:sorter]}
  to_sort.each do |post|
    the_html << "    <li><a href=\"#{post[:filename]}/\">#{post[:date]} - #{post[:time]} - #{post[:title]}</a></li>\n"
  end
  the_html << "  </ul>\n"
  erb the_html
end

get '/category/*' do
  the_category = params[:splat][0].to_s
  @title = get_title
  @subtitle = "Category: #{the_category}"
  the_html = String.new
  to_sort = Array.new
  the_html << "  <ul>\n"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename
      to_sort.push(post_info)
    end
  end
  to_sort.each do |post|
    the_date = post[:date]
    the_time = post[:time]
    if the_time =~ /AM|am/
      sorter = the_date.gsub(/-/,'') + the_time.gsub(/:| |AM|am/,'')
    end
    if the_time =~ /PM|pm/
      sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
    end
    post[:sorter] = sorter
  end
  to_sort.sort! { |a,b| b[:sorter] <=> a[:sorter]}
  to_sort.each do |post|
    if the_category == post[:category]
      the_html << "    <li><a href=\"/#{post[:filename]}/\">#{post[:date]} - #{post[:time]} - #{post[:title]}</a></li>\n"
    end
  end
  the_html << "  </ul>\n"
  erb the_html
end

get '/tag/*' do
  the_tag = params[:splat][0].to_s
  @title = get_title
  @subtitle = "Tag: #{the_tag}"
  the_html = String.new
  to_sort = Array.new
  the_html << "  <ul>\n"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename
      to_sort.push(post_info)
    end
  end
  to_sort.each do |post|
    the_date = post[:date]
    the_time = post[:time]
    if the_time =~ /AM|am/
      sorter = the_date.gsub(/-/,'') + the_time.gsub(/:| |AM|am/,'')
    end
    if the_time =~ /PM|pm/
      sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
    end
    post[:sorter] = sorter
  end
  to_sort.sort! { |a,b| b[:sorter] <=> a[:sorter]}
  to_sort.each do |post|
    for t in 0...post[:tags_array].length
      if post[:tags_array][t] == the_tag
        the_html << "    <li><a href=\"/#{post[:filename]}/\">#{post[:date]} - #{post[:time]} - #{post[:title]}</a></li>\n"
      end
    end
  end
  the_html << "  </ul>\n"
  erb the_html
end

get '/*/' do
  @title = get_title
  naked_filename = params[:splat][0].to_s
  filepath = "posts/" + naked_filename + ".md"
  if File.exists?(filepath)
    the_html = String.new
    the_text = File.read(filepath)
    post_info = separate_metadata_and_text(the_text)
    the_html << "<h2>#{post_info[:title]}</h2>\n"
    the_html << "<h3>Posted on #{post_info[:date]} at #{post_info[:time]}</h3>"
    the_html << Kramdown::Document.new(post_info[:text]).to_html + "\n"
    the_html << "<p>Category: <a href=\"/category/#{post_info[:category]}\">#{post_info[:category]}</a></p>"
    if post_info[:tags_array].length > 0
      the_html << "<p>Tags:</p>"
      the_html << "<ul>\n"
      post_info[:tags_array].each do |tag|
        the_html << "<li><a href=\"/tag/#{tag}\">#{tag}</a></li>\n"
      end
      the_html << "</ul>\n"
    end
    the_html << "<a href=\"/#{naked_filename}.md\">Markdown source</a>\n"
    @subtitle = post_info[:title]
    erb the_html
  else
    @error_page = naked_filename
    @subtitle = "404"
    erb :'404'
  end
end

get '/*.md' do
  @title = get_title
  naked_filename = params[:splat][0].to_s
  filepath = "posts/" + naked_filename + ".md"
  if File.exists?(filepath)
    post_info = separate_metadata_and_text(File.read(filepath))
    the_text = File.read(filepath)
    the_text.gsub!(/</, '&lt;')
    the_text.gsub!(/>/,'&gt;')
    @subtitle = "markdown source of " + post_info[:title]
    erb "<h2>Markdown source of <a href=\"#{naked_filename}/\">#{post_info[:title]}</a></h2>\n\n<pre>\n" + the_text + "\n</pre>"
  else
    @error_page = naked_filename + ".md"
    @subtitle = "404"
    erb :'404'
  end
end

get '/css/style.css' do
  scss :style
end