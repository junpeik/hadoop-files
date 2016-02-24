# coding: utf-8
require 'nokogiri'
require 'open-uri'

#20記事
URL = 'http://headlines.yahoo.co.jp/rss/all-dom.xml'
doc = Nokogiri::XML(open(URL))
item = doc.xpath('//rss/channel/item')

item.each do |item|
  title = item.xpath('title').text
  link = item.xpath('link').text
  news = Nokogiri::HTML(open(link))
  text = news.xpath('//*[@class="ynDetailText"]').text
  puts title
  puts text
  puts '-------------------------------------'
end
