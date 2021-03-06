require_relative "beefsteak"

def get_beef()
  beef = Beefsteak.new

  # names
  beef.title = "Beefsteak &amp; Aviation"
  beef.author = "Max Jacobson"

  # pinboard-related
  beef.pinboard_username = "maxjacobson"
  beef.number_of_links = 55
  beef.hot_tags = [
    "max_jacobson", "layabout", "beefsteak"
  ] # links with hot tags are emphasized

  # ADN Verification -- https://account.app.net/settings/verification/
  # beef.adn_handle = nil # if you don't use adn, uncomment this line
  beef.adn_handle = "maxjacobson"

  # specifically for the RSS feed
  beef.description = "and other exciting findings, by Max Jacobson"
  beef.url = "http://www.maxjacobson.net" # with no trailing slash pls
  beef.language = "en-us"
  # beef.email = nil # if you don't want to share an email address
  beef.email = "max@maxjacobson.net"

  # google analytics
  beef.analytics = true
  # beef.analytics = false
  beef.analytics_id = "UA-4982721-9"

  # beef.copyright = true # for generic (eg "(c) Max Jacobson 2013", with your name and current year)
  beef.copyright = false
  # beef.copyright = "Specific message"

  return beef
end
