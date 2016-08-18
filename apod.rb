#!/usr/bin/env ruby

require "net/http"
require "open-uri"
require "json"

# Set nasa apod api url
nasa_apod_url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"

# Set folder to save apod file
download_folder = "#{ENV['HOME']}/apodfiles"

# Request nasa apod API
puts "requesting api"
response = Net::HTTP.get(URI(nasa_apod_url))
puts "got response"

# Parse the response
date = JSON.parse(response)["date"]
explanation = JSON.parse(response)["explanation"]
media_type = JSON.parse(response)["media_type"]
title = JSON.parse(response)["title"]
url = JSON.parse(response)["url"]

puts "media type is #{media_type}"

# Check if media type is an image (may be a video or something else)
if media_type == "image"
  # Get the file name
  file_name = url[url.rindex("/")+1..url.length]

  # Print some info
  puts
  puts date
  puts
  puts title
  puts
  puts explanation
  puts

  # Write file and set image as gnome wallpaper
  File.open("#{download_folder}/#{file_name}", "wb") do |file|
    file.write open(url).read
    puts "file #{file_name} written to #{download_folder}"
    puts "setting image as wallpaper"
    system("gsettings set org.gnome.desktop.background picture-uri file://#{download_folder}/#{file_name}")
    puts "image setted as wallpaper"
  end
else
  puts "sorry, at the moment media type is not an image"
end
puts "by"
