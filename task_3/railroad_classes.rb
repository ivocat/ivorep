class Station
  attr_reader :trains_list, :name

  def initialize(name)
    @name = name
    @trains_list = []
  end

  def accommodate(train)
    @trains_list << train
  end

  def depart(train)
    @trains_list.delete(train)
  end

  def trains_list_by_type(desired_type)
    @trains_list.select {|train| train.type == desired_type}
  end
end

class Route
  attr_reader :route

  def initialize(departure_station, terminal_station)
    @route = [departure_station, terminal_station]
  end

  def add_train_stop(station, previous_station)
    previous_num = @route.rindex(previous_station)
    if previous_num != nil && previous_station != @route[-1]
      @route.insert(previous_num + 1,station)
    end
  end

  def remove_train_stop(station)
    if station != @route[0] && station != @route[-1]
      @route.delete(station)
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
    @route = []
    @location = 0
  end

  def speed_change(speed_value)
    @speed += speed_value
    @speed = 0 if @speed < 0
  end

  def full_stop
    @speed = 0
  end

  def car_add
    @cars_number += 1 if @speed == 0
  end

  def car_remove
    @cars_number -= 1 if @speed == 0
  end

  def get_route(route_object)
    @route = route_object.route
    @route[0].accommodate(self)
  end

  def move_forward
    unless @location == @route.length - 1
      @route[@location].depart(self)
      @location += 1
      @route[@location].accommodate(self)
    end
  end

  def move_back
    unless @location == 0
      @route[@location].depart(self)
      @location -= 1
      @route[@location].accommodate(self)
    end
  end

  def current_station
    @route[@location]
  end

  def previous_station
    @route[@location-1] unless @location == 0
  end

  def next_station
    @route[@location+1] unless @location == @route.length - 1
  end
end
