require_relative "manufacturer"

class TrainCar
  include Manufacturer

  def initialize(model)
    self.manufacturer = model
  end
end
