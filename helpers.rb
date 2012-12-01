def separate_metadata_and_text (text)
  meta = Hash.new
  if text =~ /^title: .+$/
    meta[:title] = text.match(/^title: .+$/)[0]
    meta[:title].gsub!(/title: /, '')
    text.gsub!(/^title: .+$\n/, '')
  else
    meta[:title] = "[Untitled Post]"
  end
  if text =~ /^date: .+$/
    meta[:date] = text.match(/^date: .+$/)[0]
    meta[:date].gsub!(/date: /, '')
    text.gsub!(/^date: .+$\n/, '')
  else
    meta[:date] = "[No date info]"
  end
  if text =~ /^time: .+$/
    meta[:time] = text.match(/^time: .+$/)[0]
    meta[:time].gsub!(/time: /, '')
    text.gsub!(/^time: .+$\n/, '')
  else
    meta[:date] = "[No time info]"
  end
  return { :metadata => meta, :text => text}
end