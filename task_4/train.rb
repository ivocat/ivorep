class Train
  attr_reader :cars_number, :type, :number, :speed

  def initialize(number, type, cars_number)
    @number = number.to_s
    @type = type.to_sym
    @cars_number = cars_number.to_i
    @speed = 0
  end

  def speed_delta(speed_value)
    @speed += speed_value
    @speed = [@speed + speed_value, 0].max
  end

  def full_stop
    @speed = 0
  end

  def car_add
    @cars_number += 1 if @speed == 0
  end

  def car_remove
    @cars_number -= 1 if @speed == 0 && @cars_number > 0
  end

  def route(route_object)
    @route = route_object
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
  
  def first_station?
    @location == 0
  end
  
  def last_station?
    @location == @route.stations.length - 1
  end
end
