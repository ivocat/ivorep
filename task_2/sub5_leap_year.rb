months_v_days = {
  1 => 31,
  2 => 28,
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

print "Введите число: "
day = gets.to_i
print "Введите месяц: "
month = gets.to_i
print "Введите год: "
year = gets.to_i

leap_year = year % 4 == 0 && !( year % 100 == 0 ) || year % 400 == 0
months_v_days[2] += 1 if leap_year

no_of_day = 0

#(month-1).times do |mo|
loop do
  month -= 1
  break if month == 0
  no_of_day += months_v_days[month]
end

no_of_day += day

puts "#{no_of_day}-й день в году"
