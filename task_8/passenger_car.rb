require_relative "train_car"

class PassengerCar < TrainCar
  attr_reader :seats_total, :seats_taken
  @seats_total = 0
  @seats_taken = 0

  def initialize(model, seats_total)
    self.manufacturer = model
    @seats_total = seats_total
  end

  def occupy_seat
    @seats_taken += 1
  end

  def seats_free
    @seats_total - @seats_taken
  end
end
