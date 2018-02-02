puts "Введите коэффициенты a, b и c квадратного уравнения ax² + bx + c = 0"
print "a ="
a = gets.chomp.to_f
print "b ="
b = gets.chomp.to_f
print "c ="
c = gets.chomp.to_f

dis = b ** 2 - 4 * a * c
puts "Дискриминант уравнения равен #{dis}"

if dis < 0
  puts "Корней нет!"
 elsif dis == 0
  puts "Корень уравнения: x = #{-b / 2 / a}"
 else
  puts "Корни уравнения: x1 = #{(Math.sqrt(dis) - b) / 2 / a}; x2 = #{-(Math.sqrt(dis) + b) / 2 / a}"
end
