require_relative "train"

class PassengerTrain < Train

  def car_add(new_car)
    super if new_car.class == PassengerCar
  end

end
