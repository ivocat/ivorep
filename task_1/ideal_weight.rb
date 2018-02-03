puts "Как вас зовут?"
name = gets.chomp
puts "Каков ваш рост?"
height = gets.to_i
idealw = height - 110
if idealw < 0
  puts "Ваш вес уже оптимальный"
else
  puts "#{name.capitalize}, ваш идеальный вес - #{idealw} кг!"
end
