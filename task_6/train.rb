require_relative "passenger_car"
require_relative "instance_counter"

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :cars, :number, :speed
  
  @@trains = {}

  def initialize(number)
    @number = number.to_s
    @cars = []
    @speed = 0
    @@trains[number] = self
  end
  
  def self.find(number)
    @@trains[number.to_s]
  end
    

  def speed_delta(speed_value)
    @speed += speed_value
    @speed = [@speed + speed_value, 0].max
  end

  def full_stop
    @speed = 0
  end

  def car_add(new_car)
    @cars << new_car if valid_car?(new_car)
  end

  def car_remove
    @cars.pop if @speed == 0
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
    @route.stations[@location-1] unless first_station?
  end

  def next_station
    @route.stations[@location+1] #unless last_station?
  end

  protected

  #Методы ниже используются только другими методами, извне их вызывать незачем, но наследоваться должны

  def first_station?
    @location == 0
  end

  def last_station?
    @location == @route.stations.length - 1
  end

  def valid_car?(new_car)
    raise NotImplementedError, 'Описать в дочерних классах'
  end
end
