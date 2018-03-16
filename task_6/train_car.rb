require_relative "manufacturer"

class TrainCar
  include Manufacturer

  def initialize(model)
    set_manufacturer(model)
  end
end
