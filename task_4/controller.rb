require_relative "station"
require_relative "route"
require_relative "station"
require_relative "train"
require_relative "train_car"
require_relative "cargo_car"
require_relative "cargo_train"
require_relative "passenger_car"
require_relative "passenger_train"

class Controller
  def initialize
    @stations = {}
    @trains = []
    @routes = []
    @cars = []
  end

  def stations_list
    if @stations == {}
      puts "Список станций пуст."
    else
      @stations.each_value do |station|
        print "#{station.name}"
        if station.trains == []
          print ", поездов нет.\n"
        else
          print ", поезда: "
          station.trains.each_with_index do |train, index|
            print "#{train.number}, " if index < station.trains.size - 1
            print "#{train.number}." if index == station.trains.size - 1
          end
        end
      end
    end
  end

  def create_station
    print "Введите название новой станции: "
    name = gets.chomp.capitalize
    if @stations.key?(name)
      puts "Станция с таким названием уже есть. Попробуйте \"#{name}-2\"."
    else
      @stations[name] = Station.new(name)
      puts "Станция #{@stations[name].name} создана!"
    end
  end



end
