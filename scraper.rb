require 'httparty'
require 'nokogiri'
require 'sinatra'


response = HTTParty.get("https://creativepeople.gr/meet-our-team/")

if response.code == 200
  puts "all fine"
else
  puts "Error: #{response.code}"
end



document = Nokogiri::HTML(response.body)

Myself = Struct.new(:image, :name, :title, :description,  :linkedIn_link)

html_person = document.css("#awsm-member-4555-7699")

i_scraped_myself = []

html_person.each do |info|
  #extract data of interest
  #from the product html
  image = info.css('img').attribute('src').value
  name = info.css('h3').text
  title = info.css('span').text
  description = info.css('p').text
  linkedIn_link = info.css('a').attribute('href').value

  # store the scraped data to struct
  myself = Myself.new(image, name, title,  description, linkedIn_link)

  i_scraped_myself << myself
end

puts i_scraped_myself


get '/' do
  @title = "I scraped myself from work!"
  @my_data = i_scraped_myself
  erb :index
end
