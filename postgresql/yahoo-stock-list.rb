# coding: utf-8
require 'nokogiri'
require 'open-uri'

#1-39
(1..2).each do |page|
  url = "http://info.finance.yahoo.co.jp/ranking/?kd=40&tm=d&vl=a&mk=3&p=#{page}"
  doc = Nokogiri::XML(open(url))
  names = doc.xpath("//*[@class='normal yjSt']")
  codes = doc.xpath("//*[@class='rankingTabledata yjM']/td[2]/a")
  stocks = doc.xpath("//*[@class='txtright bold']")

  puts "page #{page}"
  puts ""

  names.zip(codes, stocks).each do |name, code, stock|
    puts name.text
    puts "企業コード：#{code.text}"
    puts "取引値　　：#{stock.text}"
    puts '-------------------------------------'
  end
  puts ""
end