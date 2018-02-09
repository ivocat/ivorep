ten_array = []
loop do
  ten_array.push(10) if ten_array == []
  ten_array.push(ten_array.last + 5)
  break if ten_array.last == 100
end
print "#{ten_array}\n"
