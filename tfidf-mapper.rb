ARGF.each_line do |line|
  line.chomp!
  key, value = line.split(' ')
  word, text = key.split('@')

  puts "#{word}\t#{text}=#{value},1"
  #=> word  1.txt=1/54,1
end