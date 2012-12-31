# hypothetically, if you're using this and you're not max jacobson, this is the only file you need to change to use this little blogging engine

def include_analytics?
  true
end

def analytics_id
  "UA-4982721-9"
end

def pinboard_username
  return "maxjacobson"
end

def num_links
  return "55"
end

def hot_tag
  # which pinboard tag should stand out?
  # TODO make this support more than one tag?
  return "max_jacobson"
end

def paginate?
  # change to false to make the homepage display all posts
  false
end

def include_copyright?
  # can set to true to include a copyright message
  false
end

def copyright_message
  # can customize this
  "&copy; #{get_author_name} #{Time.now.year}. All rights reserved."
end

def get_posts_per_page
  # if pagination is on, this is how many items will be on each page
  posts_per_page = 20
  return posts_per_page.to_f # needs to be a float for later calculations
end

def include_tag_cloud?
  # change to false to disable the tag cloud
  true
end

def include_cat_cloud?
  # change to false to disable the category cloud
  true
end

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
  your_address = "http://www.maxjacobson.net/"
end

def get_blog_description
  # used in the RSS feed
  your_description = "the devblog of Max Jacobson."
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

def get_author_image_embed
  # files need to go in the /public folder, which will be treated as the / folder for the site
  # so this image is at /public/img/max.png but I'll assign the filename /img/max.png
  # because that's how the site will understand it
  filename = "/img/max.png"
  return "<img src=\"#{filename}\" />"
end
