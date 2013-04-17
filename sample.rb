#!/usr/local/bin/ruby -Ku

$LOAD_PATH << File.dirname(__FILE__)

require'date'
require'jp-weather-crawler'

# 北海道札幌市:47412
puts  JPWeather::Crawler.fetch_to_json(14,47412,Date.new(2012,8,1))
