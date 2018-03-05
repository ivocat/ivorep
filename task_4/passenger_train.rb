require_relative "train"
require_relative "passenger_car"

class PassengerTrain < Train

  def car_add(new_car)
    super if new_car.is_a?(PassengerCar)
  end

end
