ten_array = [10]
while ten_array.last != 100 do
    ten_array << ten_array.last + 5
  end
print "#{ten_array}\n"
