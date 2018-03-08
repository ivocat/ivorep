require_relative "train"
require_relative "passenger_car"

class PassengerTrain < Train

  def car_add(new_car)
    @cars << new_car if valid_car?(new_car)
  end

  protected

  def valid_car?(new_car)
    new_car.is_a?(PassengerCar)
  end

end
