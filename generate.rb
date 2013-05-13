require 'fileutils'

puts "Building your site"

if Dir.exists?("site")
  puts "Deleting previous build"
  FileUtils.rm_rf("site")
end

puts "Making 'site' folder"
Dir.mkdir("site")
Dir.mkdir("site/feed")
File.open("site/index.html", 'w') {|file| file.write(`curl http://localhost:9393`)}
File.open("site/feed/index.xml", 'w') {|file| file.write(`curl http://localhost:9393/feed`)}
posts = Dir.entries("posts").delete_if{|f| f == "." or f == ".."}
pages = Dir.entries("pages").delete_if{|f| f == "." or f == ".."}
posts.each do |post|
  naked = post.sub(/\.md$/, '')
  Dir.mkdir("site/#{naked}")
  File.open("site/#{naked}/index.html", 'w') {|file| file.write(`curl http://localhost:9393/#{naked}`)}
  p naked
end
