require_relative "instance_counter"
require_relative "validator"

class Route
  attr_reader :stations
  attr_accessor :assigned
  include InstanceCounter
  include Validator

  def initialize(departure_station, terminal_station)
    @stations = [departure_station, terminal_station]
    @assigned = false
    register_instance
  end

  def add_train_stop(station, previous_station)
    previous_num = @stations.index(previous_station)
    raise "такой станции нет в маршруте" if previous_num.nil?
    raise "нельзя добавить станцию после конечной" if previous_station == @stations.last
    @stations.insert(previous_num + 1,station)
  end

  def remove_train_stop(station)
    raise "нельзя удалить начальную станцию маршрута" if station == @stations.first
    raise "нельзя удалить конечную станцию маршрута" if station == @stations.last
    @stations.delete(station)
  end
end
