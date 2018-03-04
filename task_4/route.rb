class Route
  attr_reader :stations
  attr_accessor :assigned

  def initialize(departure_station, terminal_station)
    @stations = [departure_station, terminal_station]
    @assigned = false
  end

  def add_train_stop(station, previous_station)
    previous_num = @stations.index(previous_station)
    return if previous_num.nil? || previous_num == @stations.length - 1
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
