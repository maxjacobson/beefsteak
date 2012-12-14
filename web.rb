require 'sinatra'
require 'kramdown'
require_relative 'config'
require_relative 'helpers'

enable :sessions

not_found do
  @title= get_title
  @subtitle = "404"
  erb :'404'
end

error do
  @title = get_title
  @subtitle = "500"
  erb :'500'
end

get '/css/style.css' do
  scss :style
end

get '/~:page' do
  # maybe include date/time in a "last updated on" context
  @title = get_title
  the_html = String.new
  naked_filename = params[:page].to_s
  filepath = "pages/" + naked_filename + ".md"
  if File.exists?(filepath)
    the_text = File.read(filepath)
    page = separate_page_info(the_text)
    @subtitle = page[:title]
    the_html << Kramdown::Document.new(page[:text]).to_html
    the_html << "\n<hr />\n<p><a href=\"/~#{naked_filename}.md\">Markdown source of this page</a></p>\n"
  elsif File.exists?("pages/#{params[:page].to_s}")
    source_filename = params[:page].to_s
    without_md = source_filename.sub(/.md/, '')
    the_text = File.read("pages/#{params[:page].to_s}")
    the_text.gsub!(/</, '&lt;')
    the_text.gsub!(/>/,'&gt;')
    @subtitle = "markdown source of #{without_md} page"
    the_html << "<pre>\n" + the_text + "\n</pre>\n<p><a href=\"/~#{without_md}\">Back to #{without_md} page.</a></p>"
  else
    @error_page = "/~#{naked_filename}"
    @subtitle = "404"
    erb :'404'
  end
  erb the_html
end

get '/' do
  @title = get_title
  the_html = String.new
  to_sort = Array.new
  tag_cloud = Hash.new
  category_cloud = Hash.new

  pages = Dir.entries("pages")
  pages.sort!
  if pages.length > 2
    the_html << "<p>pages:</p>\n<ul>"
    pages.each do |filename|
      if filename =~ /.md/
        naked_filename = filename.sub(/.md/,'')
        the_text = File.read("pages/#{filename}")
        page_info = separate_page_info(the_text)
        the_html << "<li><a href=\"/~#{naked_filename}\">#{page_info[:title]}</a></li>"
      end
    end
    the_html << "</ul>\n"
  end

  the_html << "<p>posts:</p>\n<ul>\n"
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename

      if include_cat_cloud?
        # populate category_cloud
        if category_cloud[post_info[:category]].nil?
          category_cloud[post_info[:category]] = 1
        else
          category_cloud[post_info[:category]] += 1
        end
      end

      if include_tag_cloud?
        # populate tag_cloud
        post_info[:tags_array].each do |tag|
          if tag_cloud[tag].nil?
            tag_cloud[tag] = 1
          else
            tag_cloud[tag] += 1
          end
        end
      end

      to_sort.push(post_info)
    end
  end

  sorted = sort_posts(to_sort) # method in helper.rb


  if paginate? # if pagination is turned on
    if session[:current_page].nil? # if we dont know what page you're on
      session[:current_page] = 1 # then start at page one
    end
    posts_per_page = get_posts_per_page
    amount_of_posts = sorted.length
    amount_of_pages = (amount_of_posts / posts_per_page).ceil
    current_page = session[:current_page]
    last_post_of_current_page = (current_page * posts_per_page).to_i
    first_post_of_current_page = (last_post_of_current_page - posts_per_page).to_i + 1
    if last_post_of_current_page > amount_of_posts
      last_post_of_current_page = amount_of_posts
    end
    page_range = Hash.new
    for i in first_post_of_current_page..last_post_of_current_page
      page_range[i] = true
    end
  else # if pagination is turned off
    page_range = Hash.new
    for i in 0...sorted.length
      page_range[i] = true
    end
  end

  if session[:current_page] > amount_of_pages
    redirect '/page/1'
  end


  temp_pagination_counter = 1
  sorted.each do |post|
    if page_range[temp_pagination_counter] == true
      the_html << "    <li><a href=\"/#{post[:filename]}/\">#{post[:title]}</a> <small>Posted #{post[:relative_date]} ago.</small></li>\n"
    end
    temp_pagination_counter += 1
  end
  the_html << "  </ul>\n"

  if paginate? and amount_of_pages > 1
    @subtitle = "page #{current_page} (posts #{first_post_of_current_page}-#{last_post_of_current_page} of #{amount_of_posts})"
    the_html << "<p>Pages: "
    for i in 1..amount_of_pages
      if i != current_page
        the_html << "<a href=\"/page/#{i}\">#{i}</a>"
      else
        the_html << "<a href=\"#\">#{i}</a>"
      end
      if i != amount_of_pages
        the_html << ", "
      end
    end
    the_html << "</p>\n"
  else
    @subtitle = get_subtitle
  end

  if include_cat_cloud? or include_tag_cloud?
    the_html << "<hr />\n"
  end

  if include_cat_cloud?
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
  end


  if include_tag_cloud?
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
  end

  erb the_html
end

get '/page/:num' do
  session[:current_page] = params[:num].to_i
  redirect '/'
end

get '/category/:category' do
  the_category = params[:category].to_s
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
      the_html << "    <li><a href=\"/#{post[:filename]}/\">#{post[:title]}</a> <small>Posted #{post[:relative_date]} ago.</small></li>\n"
    end
  end
  the_html << "  </ul>\n"
  the_html << "  <p><a href=\"/category/#{the_category}/feed\">get the RSS feed for the #{the_category} category</a></p>\n"
  if the_html =~ /<li>/
    erb the_html
  else
    @subtitle = "404"
    @error_page = "category/" + the_category
    erb :'404'
  end
end

get '/tag/:tag' do
  the_tag = params[:tag].to_s
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
        the_html << "    <li><a href=\"/#{post[:filename]}/\">#{post[:title]}</a> <small>Posted #{post[:relative_date]} ago.</small></li>\n"
      end
    end
  end
  the_html << "  </ul>\n"
  the_html << "  <p><a href=\"/tag/#{the_tag}/feed\">get the RSS feed for the #{the_tag} tag</a></p>\n"
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
    the_html << "<p id=\"date\">Posted #{post_info[:relative_date]} ago at #{post_info[:time]} on #{post_info[:month_word]} #{post_info[:day]}, #{post_info[:year]}</p>\n"
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

get '/search' do
  @title = get_title
  query = params[:q]
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
      the_html << "  <li><a href=\"/#{post[:filename]}/\">#{post[:title]}</a> <small>Posted #{post[:relative_date]} ago.</small></li>\n"
    end
    the_html << "\n</ul>"
  else
    @subtitle = "No search results for " + query
  end
  the_html << "<p><a href=\"/search/#{query}/feed\">get the RSS feed for the search: #{query}</a></p>\n"
  erb the_html
end

get '/feed' do
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
  the_feed = make_feed_from_posts(sorted)
  content_type 'application/rss+xml'
  the_feed
end

get '/category/*/feed' do
  the_category = params[:splat][0].to_s
  if the_category == ""
    redirect '/'
  end
  to_sort = Array.new
  the_posts = Array.new
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename
      if post_info[:category] == the_category
        to_sort.push(post_info)
      end
    end
  end
  the_posts = sort_posts(to_sort)
  the_feed = make_feed_from_posts({:posts => the_posts, :type => :categoryfeed, :categoryname => the_category})
  content_type 'application/rss+xml'
  the_feed
end

get '/tag/*/feed' do
  the_tag = params[:splat][0].to_s
  if the_tag == ""
    redirect '/'
  end
  to_sort = Array.new
  the_posts = Array.new
  posts = Dir.entries("posts")
  posts.each do |filename|
    if filename =~ /.md/
      naked_filename = filename.sub(/.md/,'')
      the_text = File.read("posts/" + filename)
      post_info = separate_metadata_and_text(the_text)
      post_info[:filename] = naked_filename
      if post_info[:tags_array].include?(the_tag)
        to_sort.push(post_info)
      end
    end
  end
  the_posts = sort_posts(to_sort)
  the_feed = make_feed_from_posts({:posts => the_posts, :type => :tagfeed, :tagname => the_tag})
  content_type 'application/rss+xml'
  the_feed
end

get '/search/*/feed' do
  query = params[:splat][0].to_s
  if query == ""
    redirect '/'
  end
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
  the_posts = sort_posts(to_sort)
  the_feed = make_feed_from_posts({:posts => the_posts, :type => :searchfeed, :searchquery => query})
  content_type 'application/rss+xml'
  the_feed
end
# consider adding a feed for searches too...? or is that stupid?