# run the server
# go thru all the files and get the stuff and save it to a static folder
# delete the static folder?

require 'rest-open-uri'

attributes = ['css/style.css', '/']

posts = Dir.entries("posts")
posts.each do |filename|
  if filename =~ /.md/
    naked_filename = filename.sub(/.md/,'')
    attributes.push("posts/" + naked_filename + "/")
  end
end

attributes.each do |url|
  temp_html = String.new
  open("http://localhost:9393/" + url) do |h|
    h.each_line do |line|
      temp_html << line
    end
  end
  if url =~ /.md/
    # write to /whatever.html
  elsif url =~ /.scss/
    # write to /css/
  else
    # write to /index.html
  end
end