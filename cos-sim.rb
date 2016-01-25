# coding: utf-8
require 'natto'

#variables for cos similarity
natto = Natto::MeCab.new
corpus_tfidf = Hash.new {|h,k| h[k] = Hash.new{|h,k| h[k] = Hash.new{|h,k| h[k] = Array.new}}}
corpus_hash = eval File.read 'corpus-hash.txt'
topics_list = eval File.read 'topics-corpus.txt'

topics_list.each do |title, topics_value|
  corpus_hash.each do |file_name, ch_val|
    corpus_match_word = topics_list[title].keys & corpus_hash[file_name].keys
    corpus_match_word.each do |match_word|
      corpus_tfidf[title][file_name][match_word] << topics_value[match_word]
      corpus_tfidf[title][file_name][match_word] << ch_val[match_word]
      corpus_tfidf[title][file_name][match_word] << topics_value[match_word] * ch_val[match_word]
    end
    next
  end
end
#p corpus_tfidf

corpus_tfidf.each do |title, filename_match_words|
  puts "#{title}"
  cos_similarity_list = {}
  filename_match_words.each do |filename, match_words|
    topics_square_sum = 0
    corpus_square_sum = 0
    inner_product = 0
    match_words.each do |word, tfidf_pair_ip|
      topics_square_sum += tfidf_pair_ip[0] ** 2
      corpus_square_sum += tfidf_pair_ip[1] ** 2
      inner_product += tfidf_pair_ip[2]
    end
    topics_denominator = Math.sqrt(topics_square_sum)
    corpus_denominator = Math.sqrt(corpus_square_sum)
    cos_similarity = inner_product/(topics_denominator*corpus_denominator)
    cos_similarity_list[filename] = cos_similarity
    puts "#{filename}:#{cos_similarity}"
  end
  puts "☆" * cos_similarity_list.delete_if{|k, v| v.nan?}.sort_by{|k,v| v}.reverse[0][0][0].to_i
  puts
end
