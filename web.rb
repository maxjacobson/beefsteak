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
  @title= get_title
  @subtitle = "500"
  erb :'500'
end

get '/' do
  @title = get_title
  @subtitle = get_subtitle
  the_html = String.new
  to_sort = Array.new
  tag_cloud = Hash.new
  category_cloud = Hash.new
  the_html << "  <ul>\n"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename
      
      # populate category_cloud
      if category_cloud[post_info[:category]].nil?
        category_cloud[post_info[:category]] = 1
      else
        category_cloud[post_info[:category]] += 1
      end
      
      # populate tag_cloud
      post_info[:tags_array].each do |tag|
        if tag_cloud[tag].nil?
          tag_cloud[tag] = 1
        else
          tag_cloud[tag] += 1
        end
      end
      
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
      if the_time =~ /12:/
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i).to_s
      else
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
      end
    end
    post[:sorter] = sorter.to_i
  end
  
  to_sort.sort! { |a,b| b[:sorter] <=> a[:sorter]}  
  to_sort.each do |post|
    the_html << "    <li><a href=\"#{post[:filename]}/\">#{post[:date]} - #{post[:time]} - #{post[:title]}</a></li>\n"
  end
  the_html << "  </ul>\n"

  the_html << "<p>categories: "
  category_cloud.each do |cat|
    the_html << "<a href=\"/category/#{cat[0]}\">#{cat[0]} (#{cat[1]})</a> "
  end
  the_html << "</p>\n"

  the_html << "<p>tags: "
  tag_cloud.each do |tag|
    the_html << "<a href=\"/tag/#{tag[0]}\">#{tag[0]} (#{tag[1]})</a> "
  end
  the_html << "</p>\n"

  erb the_html
end

get '/category/*' do
  the_category = params[:splat][0].to_s
  if the_category == ""
    redirect '/'
  end
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
      if the_time =~ /12:/
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i).to_s
      else
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
      end
    end
    post[:sorter] = sorter.to_i
  end
  to_sort.sort! { |a,b| b[:sorter] <=> a[:sorter]}
  to_sort.each do |post|
    if the_category == post[:category]
      the_html << "    <li><a href=\"/#{post[:filename]}/\">#{post[:date]} - #{post[:time]} - #{post[:title]}</a></li>\n"
    end
  end
  the_html << "  </ul>\n"
  if the_html =~ /<li>/
    erb the_html
  else
    @subtitle = "404"
    @error_page = "category/" + the_category
    erb :'404'
  end
end

get '/tag/*' do
  the_tag = params[:splat][0].to_s
  if the_tag == ""
    redirect '/'
  end
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
      if the_time =~ /12:/
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i).to_s
      else
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
      end
    end
    post[:sorter] = sorter.to_i
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
  if the_html =~ /<li>/
    erb the_html
  else
    @subtitle = "404"
    @error_page = "tag/" + the_tag
    erb :'404'
  end
end

get '/*/' do
  @title = get_title
  naked_filename = params[:splat][0].to_s
  filepath = "posts/" + naked_filename + ".md"
  if File.exists?(filepath)
    the_html = String.new
    the_text = File.read(filepath)
    post_info = separate_metadata_and_text(the_text)
    the_html << "<p>Posted on #{post_info[:date]} at #{post_info[:time]}</p>"
    the_html << Kramdown::Document.new(post_info[:text]).to_html + "\n"
    the_html << "<hr />\n<p>Category: <a href=\"/category/#{post_info[:category]}\">#{post_info[:category]}</a></p>"
    if post_info[:tags_array].length > 0
      the_html << "<p>Tags:</p>\n"
      the_html << "<ul id=\"the-tags\">\n"
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
    erb "<pre>\n" + the_text + "\n</pre>\n<p><a href=\"#{naked_filename}/\">Back to #{post_info[:title]}</a> post.</p>"
  else
    @error_page = naked_filename + ".md"
    @subtitle = "404"
    erb :'404'
  end
end

get '/css/style.css' do
  scss :style
end