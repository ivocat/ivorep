require_relative 'train_car'

class CargoCar < TrainCar
  attr_reader :capacity, :capacity_taken, :car_name

  def initialize(car_name, capacity, manufacturer = 'РЖД')
    @car_name = car_name
    self.manufacturer = manufacturer
    @capacity = capacity
    @capacity_taken = 0.0
  end

  def occupy_space(volume)
    @capacity_taken = [@capacity_taken + volume, @capacity].min
  end

  def capacity_remaining
    @capacity - @capacity_taken
  end

  def to_s
    'товарный'
  end

  def info
    "Объём: #{capacity}, занято: #{capacity_taken}"
  end
end
