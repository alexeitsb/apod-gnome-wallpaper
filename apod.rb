#!/usr/bin/env ruby

require "net/http"
require "open-uri"
require "json"

# Set nasa apod api url.
nasa_apod_url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"

# Set folder to download apod file.
download_folder = "/home/alexei/apodfiles"

# Request nasa apod API.
system("logger -t apod Requesting API")
response = Net::HTTP.get(URI(nasa_apod_url))

# Check if media type is an image (may be a video or other).
if JSON.parse(response)["media_type"] == "image"  
  # Parse response and get url of apod file.
  apod_url = JSON.parse(response)["url"]

  # Find name of the file.
  file_name = apod_url[apod_url.rindex("/")+1..apod_url.length]  
  
  # Write file to download folder and set image as gnome wallpaper.  
  File.open("#{download_folder}/#{file_name}", "wb") do |file|
    file.write open(apod_url).read
    system("logger -t apod File #{file_name} written on #{download_folder}")
    system("gsettings set org.gnome.desktop.background picture-uri file://#{download_folder}/#{file_name}")
    system("logger -t apod File #{file_name} setted as wallpaper")
  end  
else
  system("logger -t apod Media type is not an image and nothing will be done")
end
