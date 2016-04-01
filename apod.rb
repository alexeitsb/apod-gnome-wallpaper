#!/usr/bin/env ruby

require "net/http"
require "open-uri"
require "json"

# Set nasa apod api url.
nasa_apod_url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"

# Set folder to download apod file.
download_folder = "/home/alexei/apodfiles"

# Valid file extensions (untill now I only received jpg images).
extensions = ["jpg"]

# Request nasa apod API.
system("logger [apod] requesting API")
response = Net::HTTP.get(URI(nasa_apod_url))

# Parse response and get url of apod file.
apod_url = JSON.parse(response)["url"]

# Find name of the file.
file_name = apod_url[apod_url.rindex("/")+1..apod_url.length]

# If file is an image save apod file locally and set as gnome wallpaper.
if extensions.include? file_name[file_name.rindex(".")+1..file_name.size]
  File.open("#{download_folder}/#{file_name}", "wb") do |file|
    file.write open(apod_url).read
    system("logger [apod] file #{file_name} written on #{download_folder}")
    system("gsettings set org.gnome.desktop.background picture-uri file://#{download_folder}/#{file_name}")
    system("logger [apod] #{file_name} setted as wallpaper")
  end
else
  system("logger [apod] #{file_name} is not an image and nothing will be done")
end
