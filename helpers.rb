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