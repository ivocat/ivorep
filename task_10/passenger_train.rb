require_relative 'train'
require_relative 'passenger_car'

class PassengerTrain < Train
  def self.to_s
    'пассажирский'
  end

  protected

  def valid_car?(new_car)
    new_car.is_a?(PassengerCar)
  end
end
