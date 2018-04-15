require_relative 'passenger_car'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  attr_reader :cars, :number, :speed

  @@trains = {}

  NUMBER_FORMAT = /^[А-Я\d]{3}-?[А-Я\d]{2}$/i

  validate :number, :presence
  validate :number, :format, /^[А-Я\d]{3}-?[А-Я\d]{2}$/i
  validate :number, :type, String

  def initialize(number)
    @number = number.to_s.upcase
    validate_number!
    @cars = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def self.find(number)
    @@trains[number.to_s.upcase]
  end

  def speed_delta(speed_value)
    @speed += speed_value
    @speed = [@speed + speed_value, 0].max
  end

  def full_stop
    @speed = 0
  end

  def car_add(new_car)
    new_car.index_number = @cars.length + 1
    @cars << new_car if valid_car?(new_car)
  end

  def car_remove
    @cars.last.index_number = 0
    @cars.pop if @speed.zero?
  end

  def each_car
    @cars.each do |car|
      yield car
    end
  end

  def route(route_object)
    @route = route_object
    route_object.assigned = true
    @location = 0
    current_station.accommodate(self)
  end

  def move_forward
    return if last_station?
    @route.stations[@location].depart(self)
    @location += 1
    @route.stations[@location].accommodate(self)
  end

  def move_back
    return if first_station?
    @route.stations[@location].depart(self)
    @location -= 1
    @route.stations[@location].accommodate(self)
  end

  def current_station
    @route.stations[@location]
  end

  def previous_station
    @route.stations[@location - 1] unless first_station?
  end

  def next_station
    @route.stations[@location + 1] # unless last_station?
  end

  def info
    info = number.to_s.ljust(6) + ", #{self.class}.".ljust(16)
    info += 'Вагонов нет.' if cars.empty?
    info += "Вагонов: #{cars.length}." if cars.any?
  end

  protected

  # Методы ниже используются только другими методами, извне их вызывать незачем, но наследоваться должны

  def first_station?
    @location.zero?
  end

  def last_station?
    @location == @route.stations.length - 1
  end

  def valid_car?(_new_car)
    raise NotImplementedError, 'Описать в дочерних классах'
  end

  def validate_number!
    raise 'номер поезда не указан' if @number.empty?
    raise 'номер поезда указан в неверном формате' if @number !~ NUMBER_FORMAT
  end
end
