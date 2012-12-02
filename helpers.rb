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
    category = "[No time info]"
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
    category = "[No time info]"
  end
  return { :text => text, :title => title, :date => date, :time => time, :category => category, :tags_array => tags_array }
end

def sort_posts (to_sort)
  to_sort.each do |post|
    the_date = post[:date]
    the_time = post[:time]
    if the_time =~ /AM|am/
      if the_time =~ /^[0-9]:/ # aka ONE digit before the colon
        sorter = the_date.gsub(/-/,'') + ("0" + the_time).gsub(/:| |AM|am/,'')
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