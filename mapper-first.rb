# coding: utf-8
require 'natto'
 
natto = Natto::MeCab.new

ARGF.each_line do |line|
  natto.parse(line) do |n|
    if /^名詞/ =~ n.feature.split(',')[0]
      puts "#{n.surface}@1.txt\t1"
    end
  end
end