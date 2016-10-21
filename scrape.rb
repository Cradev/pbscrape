#!/usr/bin/env ruby

# Grab the latest posts from pastebin
# and store them locally in compressed .tar.gz files.

require 'mechanize'
require 'nokogiri'
require 'json'

url = "http://pastebin.com/api_scraping.php?limit=10"

# Scrape the given URL.
def scrape(url)
    agent = Mechanize.new { |agent| agent.user_agent_alias = "Windows Firefox"}
    html = agent.get(url).body

    string = Nokogiri::HTML(html)
    return string
end

# Save the paste data in a file named after the scrape_key for that paste.
def save(parsed_url, parsed_key)
    content_to_store = scrape(parsed_url)
    current_files = Dir.glob("data/*.txt")
    # Check if the file already exists, if not, write to it.
    current_files.each do |i|
        if "#{parsed_key}.txt" != i
            File.open("data/#{parsed_key}.txt",'w') { |file| file.write(content_to_store)}
        end
    end
end

parsed = JSON.parse(scrape(url))

parsed_url = parsed[0]["scrape_url"]
parsed_key = parsed[0]["key"]

save(parsed_url, parsed_key)



