months_v_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

print "Введите число: "
day = gets.to_i
print "Введите месяц: "
month = gets.to_i
print "Введите год: "
year = gets.to_i

leap_year = year % 4 == 0 && year % 100 != 0 || year % 400 == 0
months_v_days[2] += 1 if leap_year

no_of_day = 0

(month-1).times do |mo|
  no_of_day += months_v_days[mo]
end

=begin
loop do
  month -= 1
  break if month == 0
  no_of_day += months_v_days[month]
end
=end

no_of_day += day

puts "#{no_of_day}-й день в году"
