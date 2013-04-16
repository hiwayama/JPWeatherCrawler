#!/usr/local/bin/ruby -Ku

$LOAD_PATH << File.dirname(__FILE__)

require'jp-weather-crawler'

# 北海道札幌市:47412
crawler = JPWeatherCrawler.new(14,47412)
puts crawler.fetch_to_json(2012,8,1)
