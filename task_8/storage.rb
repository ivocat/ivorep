require_relative "station"
require_relative "route"
require_relative "cargo_car"
require_relative "cargo_train"
require_relative "passenger_car"
require_relative "passenger_train"

class Storage

  attr_reader :stations, :trains, :routes, :cars

  def initialize
    @stations = {}
    @trains = {}
    @routes = []
    @cars = {}
  end

  def create_station(name)
    @stations[name] = Station.new(name)
  end

  def create_route(first_station, last_station)
    @routes << Route.new(@stations[first_station], @stations[last_station])
  end

  def add_station_to_route(input_num,new_station,after_station)
    @routes[input_num].add_train_stop(@stations[new_station], @stations[after_station])
  end

  def remove_station_from_route(input_num,deleted_station)
    raise "Нельзя удалить станцию отправления!" if deleted_station == @routes[input_num].stations.first.name
    raise "Нельзя удалить конечную станцию!" if deleted_station == @routes[input_num].stations.last.name
    @routes[input_num].remove_train_stop(@stations[deleted_station])
  end

  def create_train(number,type)
    train_types = [PassengerTrain, CargoTrain]
    train_klass = train_types.fetch(type - 1)
    @trains[number] = train_klass.new(number)
  end

  def add_car_to_train(number,car_name,cars_to_hook,car_capacity = 100)
    cars_to_hook.times do
      if @trains[number].is_a?(PassengerTrain)
        @cars[car_name] = PassengerCar.new(car_name,car_capacity)
      else
        @cars[car_name] = CargoCar.new(car_name,car_capacity)
      end
      @trains[number].car_add(@cars[car_name])
    end
  end

  def remove_car_from_train(number,cars_to_remove)
    cars_to_remove.times { @trains[number].car_remove }
  end

  def assign_route_to_train(number,input_num)
    @trains[number].route(@routes[input_num])
  end

  def route_move_train_forward(number)
    @trains[number].move_forward
  end

  def route_move_train_back(number)
    @trains[number].move_back
  end

  def station_exists?(name)
    @stations.key?(name)
  end

  def stations_not_enough?
    @stations.length < 2
  end

end
