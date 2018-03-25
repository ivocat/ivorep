require_relative "train_car"

class CargoCar < TrainCar
  attr_reader :capacity, :capacity_taken
  @capacity = 0.0
  @capacity_taken = 0.0

  def initialize(model, capacity)
    self.manufacturer = model
    @capacity = capacity
  end

  def occupy_space(volume)
    @capacity_taken += volume
  end

  def capacity_remaining
    @capacity - @capacity_taken
  end
end
