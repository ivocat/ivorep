require_relative "train_car"

class CargoCar < TrainCar
  attr_reader :capacity, :capacity_taken, :car_name

  def initialize(car_name, capacity, manufacturer = "РЖД")
    @car_name = car_name
    self.manufacturer = manufacturer
    @capacity = capacity.to_f
    @capacity_taken = 0.0
  end

  def occupy_space(volume)
    @capacity_taken += volume
    @capacity_taken = @capacity if @capacity_taken > @capacity
  end

  def capacity_remaining
    @capacity - @capacity_taken
  end
end
