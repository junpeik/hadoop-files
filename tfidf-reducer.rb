counter = Hash.new { |hash,key| hash[key] = Hash.new}

ARGF.each_line do |line|
  line.chomp!
  #line            : word  categoryA=1/70
  word, category_tf_num = line.split(/\t/)
  #category_tf_num : categoryA=1/70
  category, tf = category_tf_num.split('=')
  #tf          : 1/70
  word_per_d, word_sum = tf.split('/')
  #initialize each keys of hash
  counter[word]['category'] = [] if counter[word]['category'].nil?
  counter[word]['tf'] = [] if counter[word]['tf'].nil?
  counter[word]['df'] = 0 if counter[word]['df'].nil?

  counter[word]['category'] << category
  counter[word]['tf'] << tf.to_r
  counter[word]['df'] = counter[word]['category'].count
  #{"word"=>{"category"=>["categoryA", "categoryB"], "tf"=>["1/70", "1/80"], "df"=>2}}
end

counter.each do |word, values|
  values['category'].zip(values['tf']).each do |category, tf|
    tfidf = tf.to_f * Math.log(5.0/values['df'])
    puts "#{word}@#{category}\t#{tfidf}"
    #mouse@category  0.05
  end
end
