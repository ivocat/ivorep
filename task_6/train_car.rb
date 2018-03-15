require_relative "manufacturer"

class TrainCar
  include Manufacturer
  attr_reader :model #добавил модель вагона, чтобы не было скучно

  def initialize(model)
    @model = model.to_sym
  end
end
