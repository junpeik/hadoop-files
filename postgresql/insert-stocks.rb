# coding: utf-8
require 'active_record'
require 'nokogiri'
require 'open-uri'

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :username => 'kusumoto',
  :password => '',
  :database => 'yahoo'
)

class Stock < ActiveRecord::Base
end

#1~39ページ
(1..39).each do |page|
  url = "http://info.finance.yahoo.co.jp/ranking/?kd=40&tm=d&vl=a&mk=3&p=#{page}"
  doc = Nokogiri::XML(open(url))
  names = doc.xpath("//*[@class='normal yjSt']")
  codes = doc.xpath("//*[@class='rankingTabledata yjM']/td[2]/a")
  stocks = doc.xpath("//*[@class='txtright bold']")

  names.zip(codes, stocks).each do |name, code, stock|
    Stock.create(name: "#{name.text}", code: code.text, price: stock.text.gsub(/,/,'.'))
  end
end

p Stock.all