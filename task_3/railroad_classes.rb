class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def accommodate(train)
    @trains << train
  end

  def depart(train)
    @trains.delete(train)
  end

  def trains_by_type(desired_type)
    @trains.select {|train| train.type == desired_type}
  end
end

class Route
  attr_reader :stations

  def initialize(departure_station, terminal_station)
    @stations = [departure_station, terminal_station]
  end

  def add_train_stop(station, previous_station)
    return unless @stations.include?(previous_station)
    previous_num = @stations.index(previous_station)
    if previous_station != @stations[-1]
      @stations.insert(previous_num + 1,station)
    end
  end

  def remove_train_stop(station)
    if station != @stations[0] && station != @stations[-1]
      @stations.delete(station)
    end
  end
end

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

  def set_route(route_object)
    @route = route_object
    @location = 0
    self.current_station.accommodate(self)
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
    @route.stations[@location+1] unless last_station?
  end
  
  def first_station?
    @location == 0
  end
  
  def last_station?
    @location == @route.stations.length - 1
  end
end
