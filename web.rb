require 'sinatra'
require 'haml'
require 'kramdown'
require_relative 'beef_config'

get '/' do
  @beef = get_beef()
  @subtitle = "#{@beef.number_of_links} hot links"
  haml :links
end

get '/posts' do
  @beef = get_beef()
  haml :posts
end

get '/~*.md' do
  filepath = "pages/" + params[:splat][0].to_s + ".md"
  if File.exists?(filepath) == false
    @beef = get_beef()
    @msg = "No file exists at this address."
    @subtitle = "404"
    haml :'404'
  else
    send_file filepath, :type => :txt
  end
end

get '/~:page' do
  @beef = get_beef()
  if File.exists?("pages/#{params[:page]}.md") == false
    @msg = "There is no page at this address."
    @subtitle = "404"
    haml :'404'
  else
    @page = @beef.parse_page("#{params[:page]}.md")
    @page[:html] = Kramdown::Document.new(@page[:text]).to_html
    @subtitle = @page[:title]
    haml :page
  end
end

get '/*.md' do
  filepath = "posts/" + params[:splat][0].to_s + ".md"
  if File.exists?(filepath) == false
    @beef = get_beef()
    @msg = "No file exists at this address."
    @subtitle = "404"
    haml :'404'
  else
    send_file filepath, :type => :txt
  end
end

get '/:post' do
  @beef = get_beef()
  if File.exists?("posts/#{params[:post]}.md") == false
    @msg = "There is no post at this address."
    @subtitle = "404"
    haml :'404'
  else
    @post = @beef.parse_post("#{params[:post]}.md")
    @post[:html] = Kramdown::Document.new(@post[:text]).to_html
    @subtitle = @post[:title]
    haml :post
  end
end

get '/tag/:tag' do
  @tag = params[:tag]
  @beef = get_beef()
  @note = @beef.tag_note(@tag)
  @subtitle = "#{@tag} tag"
  haml :tag
end

get '/category/:category' do
  @category = params[:category]
  @beef = get_beef()
  @note = @beef.category_note(@category)
  @subtitle = "#{@category} category"
  haml :category
end