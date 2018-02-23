class Controller
  def initialize
    stations = {}
    trains = {}
    routes = {}
    cars = {}
  end

  def stations_list
    if stations_all == {}
      puts "Список станций пуст."
    else
      stations_all.each do |station|
        print "#{station}"
        if station.trains = []
          print ", поездов нет."
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
    if stations[name].nil?
      @stations[name] = Station.new(name)
    else
      puts "Станция с таким названием уже есть. Попробуйте \"#{name}-2\"."
    end
  end

    

end
