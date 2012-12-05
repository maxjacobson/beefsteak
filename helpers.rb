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
  if diff < 0
    relative_date = "in the future...?"
  elsif diff < 60
    relative_date = "less than a minute ago"
  elsif diff < 3600
    minutes = (diff/60).floor
    if minutes == 1
      relative_date = "#{minutes} minute ago"
    else
      relative_date = "#{minutes} minutes ago"
    end
  elsif diff < 86400
    hours = (diff/3600).floor
    if hours == 1
      relative_date = "#{hours} hour ago"
    else
      relative_date = "#{hours} hours ago"
    end
  elsif diff < 31536000
    days = (diff/86400).floor
    if days == 1
      relative_date = "#{days} day ago"
    else
      relative_date = "#{days} days ago"
    end
  else
    relative_date = "more than a year ago"
  end
  
  the_months = {"01" => "jan", "02" => "feb", "03" => "mar", "04" => "apr", "05" => "may", "06" => "jun", "07" => "jul", "08" => "oct", "09" => "sep", "10" => "oct", "11" => "nov", "12" => "dec" }
  month_word = the_months[month]

  return { :text => text, :title => title, :date => date, :time => time, :relative_date => relative_date, :month_word => month_word, :year => year, :month => month, :day => day, :category => category, :tags_array => tags_array }
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