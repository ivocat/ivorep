require_relative "train_car"

class PassengerCar < TrainCar
  attr_reader :seats_total, :seats_taken, :car_name

  def initialize(car_name, seats_total, manufacturer = "РЖД")
    @car_name = car_name
    self.manufacturer = manufacturer
    @seats_total = seats_total
    @seats_taken = 0
  end

  def occupy_seat
    @seats_taken = [@seats_taken + 1, @seats_total].min
  end

  def seats_remaining
    @seats_total - @seats_taken
  end

  def to_s
    "пассажирский"
  end

  def info
    "Мест: #{self.seats_total}, мест занято: #{self.seats_taken}"
  end
end
