#!/usr/bin/env ruby

require "net/http"
require "open-uri"
require "json"

# Set nasa apod api url.
nasa_apod_url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"

#Set folder to download apod file.
download_folder = "/home/alexei/apodfiles"

# Request nasa apod API.
response = Net::HTTP.get(URI(nasa_apod_url))

# Parse response and get url of apod file.
apod_url = JSON.parse(response)["url"]

# Find name of the file.
file_name = apod_url[apod_url.rindex("/")+1..apod_url.length]

# Save apod file locally.
File.open("#{download_folder}/#{file_name}", "wb") do |file|
  file.write open(apod_url).read
end

# Set gnome wallpaper with downloaded apod file.
system("gsettings set org.gnome.desktop.background picture-uri file://#{download_folder}/#{file_name}")
