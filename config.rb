# hypothetically, if you're using this and you're not max jacobson, this is the only file you need to change to use this little blogging engine

def get_title
  your_blogs_name = "Beefsteak &amp; Aviation"
end

def get_subtitle
  your_homepages_subtitle = "home"
end

def get_author_name
  your_name = "Max Jacobson"
end

def get_blog_address
  # used in the RSS feed
  # include the final slash plssss
  your_address = "http://devblog.maxjacobson.net/"
end

def get_blog_description
  # used in the RSS feed
  your_description = "The devblog of Max Jacobson"
end

def get_blog_language
  # used in the RSS feed
  your_language = "en-us"
end

def get_email_address
  # used in the RSS feed
  # this is option. if you don't want to share your email address, just delete that line and let it be nil
  your_email_address = nil
  your_email_address = "max@maxjacobson.net"
end