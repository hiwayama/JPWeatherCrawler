#!/usr/local/bin/ruby -Ku

$LOAD_PATH << File.dirname(__FILE__)

require'get-weather-data'

# 北海道札幌市:47412
obj = GetWeatherData.new(14,47412)
puts obj.get_to_json(2012,8,1)
