require_relative "manufacturer"

class TrainCar
  include Manufacturer
  attr_accessor :index_number
  @index_number = 0

  def initialize(model)
    self.manufacturer = model
  end
end
