module SweepMethods
  block_cars = lambda do |car|
    puts "    "
    print car.number , ", "
    if car.class == PassengerCar
      print "пассажирский. Мест: " , car.seats_total , ", мест занято: " , car.seats_taken
    else
      print "товарный. Объём: " , car.capacity_total , ", занято: " , car.capacity_taken
    end
  end

  block_trains = lambda do |train|
    puts "  "
    print train.number , ", " , train.class.to_s , ". Вагонов: " , train.cars.length
    train.iterate_cars(block_cars)
  end
end
