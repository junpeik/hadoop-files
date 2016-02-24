#initialize value with 0
counter = Hash.new{|h,k| h[k] = 0 }

ARGF.each_line do |line|
  line.chomp!
  text, num = line.split(/\t/)
  counter[text] += num.to_i
end

counter.each do |k,v|
  puts "#{k}\t#{v}/#{counter.size}"
end 
