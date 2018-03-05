require_relative "train"
require_relative "cargo_car"

class CargoTrain < Train

  def car_add(new_car)
    super if new_car.is_a?(CargoCar)
  end

end
