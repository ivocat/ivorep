shop_list = {}
loop do
  print "Введине название товара или stop, чтобы завершить ввод: "
  goods = gets.chomp
  break if goods.downcase == "stop"
  print "Введите цену товара (за штуку): "
  price_input = gets.to_f
  print "Введите количество товаров: "
  quantity_input = gets.to_f
  shop_list[goods] = {
    price: price_input,
    quantity: quantity_input
  }
end

total_price = 0

shop_list.each do |name, subtotal|
  subtotal_number = subtotal[:price] * subtotal[:quantity]
  puts "#{name} x#{subtotal[:quantity].round(2)}; "\
  "цена: #{subtotal[:price].round(2)}. "\
  "Сумма: #{subtotal_number.round(2)}"
  total_price += subtotal_number
end
puts "Итоговая сумма покупок: #{total_price.round(2)}"
