puts "Как вас зовут?"
name = gets.chomp.to_s
puts "Каков ваш рост?"
height = gets.chomp.to_i
if height - 110 < 0
  puts "Ваш вес уже оптимальный"
else
  puts "#{name.capitalize}, ваш идеальный вес - #{height - 110} кг!"
end
