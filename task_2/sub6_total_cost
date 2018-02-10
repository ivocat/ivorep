shop_list = Hash.new(0)
loop do
  print "Введине название товара или stop, чтобы завершить ввод: "
  goods = gets.chomp
  break if goods.downcase == "stop"
  print "Введите цену товара (за штуку): "
  price_input = gets.to_f
  print "Введите количество товаров: "
  quantity_input = gets.to_i
  shop_list[goods] = {
    price: price_input,
    quantity: quantity_input
  }
end

total_price = 0
shop_list.values.each do |subtotal|
  total_price += subtotal[:price] * subtotal[:quantity]
end

puts shop_list
puts "Итоговая сумма покупок: #{total_price}"
