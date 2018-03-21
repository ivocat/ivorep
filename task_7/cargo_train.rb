require_relative "train"
require_relative "cargo_car"

class CargoTrain < Train

  def self.normal_name
    "товарный"
  end

  protected

  def valid_car?(new_car)
    new_car.is_a?(CargoCar)
  end

end
