def get_pages_for_header
  the_html = String.new
  pages = Dir.entries("pages")
  pages.sort!
  if pages.length > 2
    the_html << "<div class=\"pages_list\"><ul>\n"
    the_html << "  <li><a href=\"/\">links</a></li>\n"
    the_html << "  <li><a href=\"/posts\">posts</a></li>\n"
    pages.each do |filename|
      if filename =~ /.md/
        naked_filename = filename.sub(/.md/,'')
        the_text = File.read("pages/#{filename}")
        page_info = separate_page_info(the_text)
        the_html << "  <li><a href=\"/~#{naked_filename}\">#{page_info[:title]}</a></li>\n"
      end
    end
    the_html << "</ul>\n</div>\n"
  end
  return the_html
end
def make_feed_from_posts (info)
  # example info:
  # info = {:posts => the_posts, :type => :searchfeed, :searchquery => query}
  posts = info[:posts]
  if info[:type] == :tagfeed
    title = "#{unhyphenate(info[:tagname])} tag | #{get_title}"
    description = get_blog_description + " Just the posts tagged #{info[:tagname]}."
    feed_link = "#{get_blog_address}tag/#{info[:tagname]}"
  elsif info[:type] == :categoryfeed
    title = "#{unhyphenate(info[:categoryname])} category | #{get_title}"
    description = get_blog_description + " Just the posts categorized #{info[:categoryname]}."
    feed_link = "#{get_blog_address}category/#{info[:categoryname]}"
  elsif info[:type] == :searchfeed
    title = "#{info[:searchquery]} search | #{get_title}"
    description = get_blog_description + " Just the posts matching a search for #{info[:searchquery]}."
    feed_link = "#{get_blog_address}search?q=#{info[:searchquery]}"
  else
    title = get_title
    description = get_blog_description
    feed_link = get_blog_address
  end
  the_feed = String.new
  the_feed << "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n"
  the_feed << "<rss version=\"2.0\">\n"
  the_feed << "<channel>\n"
  the_feed << "  <title>#{title}</title>\n"
  the_feed << "  <link>#{feed_link}</link>\n"
  the_feed << "  <description>#{description}</description>\n"
  the_feed << "  <language>#{get_blog_language}</language>\n"
  the_feed << "  <updated>#{Time.now}</updated>"
  if get_email_address != nil
    the_feed << "  <webMaster>#{get_email_address}</webMaster>\n"
  end
  posts.each do |post|
    the_feed << "  <item>\n"
    the_feed << "    <title>#{post[:title]}</title>\n"
    the_feed << "    <link>#{get_blog_address}#{post[:filename]}</link>\n"
    the_feed << "    <description><![CDATA[#{Kramdown::Document.new(post[:text]).to_html}]]></description>\n"
    if get_email_address != nil
      the_feed << "    <author><name>#{get_author_name}</name></author>\n"
    end
    the_feed << "  </item>\n"
  end
  the_feed << "</channel>\n"
  the_feed << "</rss>\n"
  return the_feed
end

def secs_to_str (n)
  if n < 0
    return "in the future...?"
  elsif n < 60
    if n == 1
      return "1 second"
    else
      return "#{n} seconds"
    end
  elsif n < 3600
    minutes = (n/60).floor
    if minutes == 1
      return "#{minutes} minute"
    else
      return "#{minutes} minutes"
    end
  elsif n < 86400
    hours = (n/3600).floor
    if hours == 1
      return "#{hours} hour"
    else
      return "#{hours} hours"
    end
  elsif n < 31536000
    days = (n/86400).floor
    if days == 1
      return "#{days} day"
    else
      return "#{days} days"
    end
  else
    years = (n/31536000).floor
    secs_spillover = n % 31536000
    if years == 1
      return "1 year and #{secs_to_str(secs_spillover)}"
    else
      return "#{years} years and #{secs_to_str(secs_spillover)}"
    end
  end
end

def separate_page_info (text)
  title = text.match(/^title: (.+)$/)[1]
  text.sub!(/^title: .+$\n\n/, '')
  return {:title => title, :text => text}
end

def separate_metadata_and_text (text)
  if text =~ /^title: .+$/
    title = text.match(/^title: .+$/)[0]
    title.gsub!(/title: /, '')
    text.sub!(/^title: .+$\n/, '')
  else
    title = "[Untitled Post]"
  end
  if text =~ /^date: .+$/
    date = text.match(/^date: .+$/)[0]
    date.gsub!(/date: /, '')
    text.sub!(/^date: .+$\n/, '')
  else
    date = "[No date info]"
  end
  if text =~ /^time: .+$/
    time = text.match(/^time: .+$/)[0]
    time.gsub!(/time: /, '')
    text.sub!(/^time: .+$\n/, '')
  else
    time = "[No time info]"
  end
  if text =~ /^category: .+$/
    category = text.match(/^category: .+$/)[0]
    category.gsub!(/category: /, '')
    category.gsub!(/ /, '-')
    category.downcase!
    text.sub!(/^category: .+$\n/, '')
  else
    category = "[No category info]"
  end
  if text =~ /^tags: .+$/
    tags = text.match(/^tags: .+$/)[0]
    tags.gsub!(/tags: /, '')
    text.sub!(/^tags: .+$\n/, '')
    tags_array = tags.split(/, /)
    tags_array.each do |t|
      t.gsub!(/ /, '-')
      t.gsub!(/\'/, '')
      t.downcase!
    end
  else
    tags = "[No tags info]"
  end

  date_reg = /(\d{4})-(\d{2})-(\d{2})/
  time_reg = /(\d{1,2}):(\d{2}) ((AM|PM))/
  year = date.match(date_reg)[1]
  month = date.match(date_reg)[2]
  day = date.match(date_reg)[3]
  hour = time.match(time_reg)[1]
  min = time.match(time_reg)[2]
  if time.match(time_reg)[3] == "PM"
    hour = (hour.to_i + 12).to_s
  end
  time_now = Time.now
  time_then = Time.new(year, month, day, hour, min)
  diff = time_now - time_then

  the_months = {"01" => "jan", "02" => "feb", "03" => "mar", "04" => "apr", "05" => "may", "06" => "jun", "07" => "jul", "08" => "oct", "09" => "sep", "10" => "oct", "11" => "nov", "12" => "dec" }
  month_word = the_months[month]

  return { :text => text, :title => title, :date => date, :time => time, :relative_date => secs_to_str(diff), :month_word => month_word, :year => year, :month => month, :day => day, :category => category, :tags_array => tags_array }
end

def sort_posts (to_sort)
  to_sort.each do |post|
    the_date = post[:date]
    the_time = post[:time]
    if the_time =~ /AM|am/
      if the_time =~ /^[0-9]:/ # aka ONE digit before the colon
        sorter = the_date.gsub(/-/,'') + ("0" + the_time).gsub(/:| |AM|am/,'')
      elsif the_time =~ /^12:/
        sorter = the_date.gsub(/-/,'') + ("00" + the_time).gsub(/:| |AM|am|12/,'')
      else
        sorter = the_date.gsub(/-/,'') + the_time.gsub(/:| |AM|am/,'')
      end
    end
    if the_time =~ /PM|pm/
      if the_time =~ /12:/
        sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i).to_s
      else
        if the_time =~ /^[0-9]:/ # aka ONE digit before the colon
          sorter = the_date.gsub(/-/,'') + ((("0" + the_time).gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
        else
          sorter = the_date.gsub(/-/,'') + ((the_time.gsub(/:| |PM|pm/,'')).to_i + 1200).to_s
        end
      end
    end
    post[:sorter] = sorter.to_i
  end

  # to_sort.each do |item|
  #   puts item[:sorter]
  # end
  #
  to_sort.sort! { |a,b| b[:sorter] <=> a[:sorter]}
  # puts
  # puts
  # to_sort.each do |item|
  #   puts item[:sorter]
  # end
  return to_sort
end

def sort_cloud (to_sort)
  # puts to_sort.inspect
  sorted = to_sort.sort_by{|key, value| value}
  # puts sorted.inspect
  return sorted.reverse!
end

def unhyphenate (string)
  unfrozen = string.dup
  unfrozen.gsub!(/-/, ' ')
  return unfrozen
end
