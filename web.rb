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

get '/search' do
  @title = get_title
  query = params[:q]

  @title = get_title
  the_html = String.new
  to_sort = Array.new
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      if the_text =~ Regexp.new(query, true) # I _think_ the true here means that it will be case insensitive
        post_info = separate_metadata_and_text(the_text)
        post_info[:filename] = naked_filename
        to_sort.push(post_info)
      end
    end
  end
  if to_sort.length > 0
    sorted = sort_posts(to_sort)
    if sorted.length == 1
      @subtitle = "There are #{sorted.length} search result for " + query
    else
      @subtitle = "There are #{sorted.length} search results for " + query
    end
    the_html << "<ul>\n"
    sorted.each do |post|
      the_html << "  <li><a href=\"/#{post[:filename]}/\">#{post[:date]} - #{post[:time]} - #{post[:title]}</a></li>\n"
    end
    the_html << "\n</ul>"
  else
    @subtitle = "No search results for " + query
  end
  erb the_html
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

  sorted = sort_posts(to_sort) # method in helper.rb

  sorted.each do |post|
    the_html << "    <li><a href=\"#{post[:filename]}/\">#{post[:title]}</a> <small>Posted #{post[:days_since]} days ago.</small></li>\n"
  end
  the_html << "  </ul>\n"
  
  the_html << "<hr />\n"

  the_html << "<p>categories: "
  sorted_cats = sort_cloud(category_cloud) # a method in helpers.rb
  i = 1
  sorted_cats.each do |cat|
    the_category = cat[0]
    the_category_unhyphenated = unhyphenate(the_category)
    the_category_count = cat[1]
    the_html << "<a href=\"/category/#{the_category}\">#{the_category_unhyphenated} <span class=\"badge\">(#{the_category_count})</span></a>"
    if i != sorted_cats.length
      the_html << ", "
    end
    i += 1
  end
  the_html << "</p>\n"

  the_html << "<p>tags: "
  sorted_tags = sort_cloud(tag_cloud) # a method in helpers.rb
  i = 1
  sorted_tags.each do |tag|
    the_tag = tag[0]
    the_tag_unhyphenated = unhyphenate(the_tag)
    the_tag_count = tag[1]
    the_html << "<a href=\"/tag/#{the_tag}\">#{the_tag_unhyphenated} <span class=\"badge\">(#{the_tag_count})</span></a>"
    if i != sorted_tags.length
      the_html << ", "
    end
    i += 1
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
  @subtitle = "Category: #{unhyphenate(the_category)}"
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
  sorted = sort_posts(to_sort) # method in helper.rb
  sorted.each do |post|
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
  @subtitle = "Tag: #{unhyphenate(the_tag)}"
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
  sorted = sort_posts(to_sort) # method in helper.rb
  sorted.each do |post|
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
    the_html << "<p id=\"date\">Posted #{post_info[:days_since]} days ago on #{post_info[:date]} at #{post_info[:time]}</p>\n"
    the_html << "<div class=\"instapaper_body\">\n" + Kramdown::Document.new(post_info[:text]).to_html + "\n</div>\n"
    the_html << "<hr />\n<p>Category: <a href=\"/category/#{post_info[:category]}\">#{unhyphenate(post_info[:category])}</a></p>"
    if post_info[:tags_array].length > 0
      the_html << "<p>Tags: "
      i = 1
      post_info[:tags_array].each do |tag|
        the_html << "<a href=\"/tag/#{tag}\">#{unhyphenate(tag)}</a>"
        if i != post_info[:tags_array].length
          the_html << ", "
        end
        i +=1
      end
      the_html << "</p>\n"
    end
    the_html << "<a href=\"/#{naked_filename}.md\">Markdown source of this post</a>\n"
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

get '/feed' do
  the_feed = String.new
  the_feed << "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n"
  the_feed << "<rss version=\"2.0\">\n"
  the_feed << "<channel>\n"
  the_feed << "  <title>#{get_title}</title>\n"
  the_feed << "  <link>#{get_blog_address}</link>\n"
  the_feed << "  <description>#{get_blog_description}</description>\n"
  the_feed << "  <language>#{get_blog_language}</language>\n"
  the_feed << "  <updated>#{Time.now}</updated>"
  if get_email_address != nil
    the_feed << "  <webMaster>#{get_email_address}</webMaster>\n"
  end
  
  to_sort = Array.new
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

  sorted = sort_posts(to_sort) # method in helper.rb
  sorted.each do |post|
    the_feed << "  <item>\n"
    the_feed << "    <title>#{post[:title]}</title>\n"
    the_feed << "    <link>#{get_blog_address}#{post[:filename]}/</link>\n"
    the_feed << "    <description><![CDATA[#{Kramdown::Document.new(post[:text]).to_html}]]></description>\n"
    if get_email_address != nil
      the_feed << "    <author><name>#{get_author_name}</name></author>\n"
    end
    the_feed << "  </item>\n"
  end

  the_feed << "</channel>\n"
  the_feed << "</rss>\n"
  
  content_type 'application/rss+xml'
  the_feed
end