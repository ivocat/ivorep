puts "Введите длины трёх сторон треугольника через запятую"
sides = gets.chomp.gsub(" ","").split(",")
sides.sort!.map! {|s| s.to_f}

if sides.length < 3
  puts "Вы ввели меньше трёх сторон"
  exit
elsif sides.length > 3
  puts "Вы ввели больше трёх сторон"
  exit
elsif sides.inject(:*) == 0
  puts "Вы ввели неправильные данные"
  exit
end

isosceles = (sides[0] == sides [1]) || (sides[0] == sides[2]) || (sides[1] == sides[2])
right = (sides[2]**2).round(3) == ( sides[0]**2 + sides[1]**2 ).round(3)

if isosceles && right
  puts "Трегуольник прямоугольный и равнобедренный"
elsif right
  puts "Треугольник прямоугольный"
else
  puts "Треугольник не прямоугольный"
end
