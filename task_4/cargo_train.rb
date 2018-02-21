class CargoTrain < Train
  
  def car_add(new_car)
    super if new_car.class == CargoCar
  end
  
end
