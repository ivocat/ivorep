puts "Введите длину основания треугольника"
base = gets.chomp.to_f
puts "Введите высоту треугольника"
height = gets.chomp.to_f
if base * height <= 0
  puts "Такого треугольника быть не может."
else
  puts "Площадь треугольника: #{base * height}."
end
