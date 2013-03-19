class Beefsteak
  attr_accessor :title, :description, :author,
    :pinboard_username, :number_of_links, :hot_tags,
    :url, :language, :email,
    :analytics, :analytics_id,
    :copyright

  def initialize
    @copyright = true
  end

  def pages
    if @pages.nil? == false
      return @pages
    end
    @pages = []
    if Dir.exists?("pages")
      filenames = Dir.entries("pages").delete_if{|f| f == "." or f == ".."}
      filenames.each do |filename|
        page = parse_page filename
        @pages.push page
      end
    end
    return @pages
  end

  def posts
    return @posts if @posts.nil? == false
    @posts = []
    if Dir.exists?("posts")
      filenames = Dir.entries("posts").delete_if{|f| f == "." or f == ".."}
      filenames.each do |filename|
        post = parse_post filename
        @posts.push post if post[:publish] == true
      end
    end
    return @posts.sort_by{|post| post[:date]}.reverse
  end

  def posts_with_tag(tag)
    @posts = self.posts if @posts.nil?
    return @posts.keep_if{|post| post[:tags].include? tag}
  end

  def posts_with_category(cat)
    @posts = self.posts if @posts.nil?
    return @posts.keep_if{|post| post[:category] == cat}
  end
  
  def clouds
    return {:tags => @tag_cloud, :cats => @cat_cloud} if @tag_cloud.nil? == false and @cat_cloud.nil? == false
    @posts = self.posts if @posts.nil?
    @tag_cloud = {}
    @cat_cloud = {}
    @posts.each do |post|
      cat = post[:category]
      tags = post[:tags]
      @cat_cloud[cat] = @cat_cloud[cat].nil? ? 1 : @cat_cloud[cat] + 1
      tags.each do |tag|
        @tag_cloud[tag] = @tag_cloud[tag].nil? ? 1 : @tag_cloud[tag] + 1
      end
    end
    return {:tags => @tag_cloud.sort_by{|k,v| v}.reverse, :cats => @cat_cloud.sort_by{|k,v| v}.reverse}
  end

  def copyright_message
    if @copyright.class == String
      return @copyright
    else
      return "&copy; #{@author} #{Time.now.year}"
    end
  end

  def parse_page(filename)
    naked_filename = filename.gsub(/\..+$/,'')
    raw_text = File.open("pages/#{filename}").read
    title = raw_text.match(/^title: (.+)$/)[1]
    text = raw_text.sub(/^title: .+$\n\n/, '')
    return {
      :title => title,
      :text => text,
      :filename => filename,
      :url => "/~#{naked_filename}"
    }
  end

  def parse_post(filename)
    naked_filename = filename.gsub(/\..+$/,'')
    post = {
      :publish => true,
      :filename => filename,
      :naked_filename => naked_filename,
      :url => "/#{naked_filename}"
    }

    raw_text = File.open("posts/#{filename}").read
    chunks = raw_text.split("\n\n")
    metadata = chunks.shift.split("\n")
    post[:text] = chunks.join("\n\n")

    metadata.each do |line|
      kvp = /(^[^\:]+)\s{0,}\:\s{0,}([^\s].{0,})$/
      k = line.match(kvp)[1]
      v = line.match(kvp)[2]
      post[k.to_sym] = v
    end

    if post[:date].nil? or post[:time].nil? or post[:title].nil? or post[:draft].nil? == false
      return {:publish => false}
    end

    if post[:tags].nil? == false
      post[:tags] = post[:tags]
        .split(",")
        .map { |x|
          x.gsub(/\s{0,}(.+)\s{0,}/,'\1') # remove extraneous spacing
            .gsub(/\s{1,}/, '-') # hyphenate
            .downcase
        }
    end

    if post[:category].nil? == false
      post[:category] = post[:category].downcase.gsub(/\s{1,}/, '-')
    end


    date = post[:date]
    time = post[:time]
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
    post[:date] = time_then
    post[:diff] = secs_to_str(time_now - time_then)

    return post
  end

  def secs_to_str (n)
    if n < 0
      return "in the future"
    elsif n < 60
      if n == 1
        return "1 second ago"
      else
        return "#{n} seconds ago"
      end
    elsif n < 3600
      minutes = (n/60).floor
      if minutes == 1
        return "#{minutes} minute ago"
      else
        return "#{minutes} minutes ago"
      end
    elsif n < 86400
      hours = (n/3600).floor
      if hours == 1
        return "#{hours} hour ago"
      else
        return "#{hours} hours ago"
      end
    elsif n < 31536000
      days = (n/86400).floor
      if days == 1
        return "#{days} day ago"
      else
        return "#{days} days ago"
      end
    else
      years = (n/31536000).floor
      secs_spillover = n % 31536000
      if years == 1
        return "1 year and #{secs_to_str(secs_spillover)} ago"
      else
        return "#{years} years and #{secs_to_str(secs_spillover)} ago"
      end
    end
  end

end

