# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'natto'

#20記事
URL = 'http://headlines.yahoo.co.jp/rss/all-dom.xml'
doc = Nokogiri::XML(open(URL))
item = doc.xpath('//rss/channel/item')
natto = Natto::MeCab.new
topics_list = Hash.new
tf = Hash.new{|h,k| h[k] = Hash.new(0)}
idf = Hash.new(0)
output = Hash.new{|h,k| h[k] = Hash.new(0)}

item.each do |item|
  title = item.xpath('title').text
  link = item.xpath('link').text
  news = Nokogiri::HTML(open(link))
  text = news.xpath('//*[@class="ynDetailText"]').text
  puts title
  puts text
  puts '-------------------------------------'
  topics_list[title] = text
end

#TF
topics_list.each do |title, text|
  natto.parse(text) do |n|
    if /^名詞/ =~ n.feature.split(',')[0]
      #p n.surface
      tf[title]["#{n.surface}"] += 1
    end
  end
end

#IDF
tf.values.each do |hash|
  hash.each do |key, value|
    idf[key] += 1
  end
end

#corpus : TFIDF
File.open('topics-corpus.txt', 'w') do |file|
  tf.each do |title, word_value|
    word_value.each do |word, value|
      tf_value = value.to_f/tf[title].length
      idf_value = Math.log(20.0/idf[word])
      tfidf = tf_value * idf_value
      output[title][word] = tfidf
      #file.puts "#{word}@#{title}\t#{tfidf}"
    end
  end
  file.puts output
end