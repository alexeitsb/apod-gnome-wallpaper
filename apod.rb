#!/usr/bin/env ruby

require "net/http"
require "open-uri"
require "json"

# Set nasa apod api url
nasa_apod_url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"

# Set folder to save apod file
download_folder = "/home/alexei/apodfiles"

# Request nasa apod API
system("echo requesting api")
response = Net::HTTP.get(URI(nasa_apod_url))
system("echo got response")

# Parse the response
date = JSON.parse(response)["date"]
explanation = JSON.parse(response)["explanation"]
media_type = JSON.parse(response)["media_type"]
title = JSON.parse(response)["title"]
url = JSON.parse(response)["url"]

system("echo media type is #{media_type}")

# Check if media type is an image (may be a video or something else)
if media_type == "image"
  # Get the file name
  file_name = url[url.rindex("/")+1..url.length]

  # Print some info
  system("echo")
  system("echo #{date}")
  system("echo")
  system("echo #{title}")
  system("echo")
  system("echo #{explanation}")
  system("echo")

  # Write file and set image as gnome wallpaper
  File.open("#{download_folder}/#{file_name}", "wb") do |file|
    file.write open(url).read
    system("echo file #{file_name} written to #{download_folder}")
    system("echo setting image as wallpaper")
    system("gsettings set org.gnome.desktop.background picture-uri file://#{download_folder}/#{file_name}")
    system("echo image setted as wallpaper")
  end
else
  system("echo sorry, at the moment media type is not an image")
end
system("echo by")
