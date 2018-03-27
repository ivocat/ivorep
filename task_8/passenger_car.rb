require_relative "train_car"

class PassengerCar < TrainCar
  attr_reader :seats_total, :seats_taken, :car_name
  @seats_total = 0

  def initialize(car_name, seats_total, manufacturer = "РЖД")
    @car_name = car_name
    self.manufacturer = manufacturer
    @seats_total = seats_total
    @seats_taken = 0
  end

  def occupy_seat
    @seats_taken += 1 if @seats_taken < @seats_total
  end

  def seats_remaining
    @seats_total - @seats_taken
  end
end
