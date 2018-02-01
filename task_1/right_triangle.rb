puts "Введите длины трёх сторон треугольника через запятую"
sides = gets.chomp.gsub(" ","").split(",")
sides.map! {|s| s.to_f}
sides.sort!

if sides.length < 3
  puts "Вы ввели меньше трёх сторон"
  exit
elsif sides.length > 3
  puts "Вы ввели больше трёх сторон"
  exit
end

isosceles = (sides[0] == sides [1]) || (sides[0] == sides[2]) || (sides[1] == sides[2])
right = sides[2]**2 == ( sides[0]**2 + sides[1]**2 )
isoright = isoright && right

if isoright
  puts "Трегуольник прямоугольный и равнобедренный"
elsif right
  puts "Треугольник прямоугольный"
else
  puts "Треугольник не прямоугольный"
end

a = Math.sqrt(sides[0]**2 + sides[1]**2)
sides.each {|s| puts s}
puts a
