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
      puts "Список станций:"
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
    if station_exists?(name)
      puts "Станция с таким названием уже есть. Попробуйте \"#{name}-2\"."
    else
      @stations[name] = Station.new(name)
      puts "Станция #{@stations[name].name} создана!"
    end
  end

  def create_route
    if stations_not_enough?
      puts "Недостаточно станций для создания маршрута."
      return
    end
    puts "Введите начальную станцию маршрута:"
    first_station = gets.chomp.capitalize
    unless station_exists?(first_station)
      puts "Такой станции нет!"
      return
    end
    puts "Введите конечную станцию маршрута:"
    last_station = gets.chomp.capitalize
    unless station_exists?(last_station)
      puts "Такой станции нет!"
      return
    end
    @routes << Route.new(first_station, last_station)
    puts "Маршрут #{first_station} — #{last_station} создан."
  end

  def add_station_to_route
    if @routes.empty?
      puts "Ни одного маршрута ещё не создано."
    elsif stations_not_enough?
      puts "Недостаточно станций для дополнения маршрута."
    else
      route_choose_prompt
      print "> "
      input_num = gets.to_i
      puts "Введите название новой станции в маршруте:"
      new_station = gets.chomp.capitalize #плюс проверки сущ-я станции
      puts "Введите название станции, после которой следует добавить новую:"
      after_station = gets.chomp.capitalize #плюс проверки сущ-я станции
      @routes[input_num - 1].add_train_stop(new_station, after_station)
      puts "Станция добавлена в маршрут!"
    end
  end

  def remove_station_from_route
    if @routes.empty?
      puts "Ни одного маршрута ещё не создано."
    else
      route_choose_prompt
      print "> "
      input_num = gets.to_i
      puts "Введите название удаляемой станции:"
      delete_station = gets.chomp.capitalize
      @routes[input_num - 1].remove_train_stop(delete_station)
      puts "Станция удалена!" #может и не удалена, если первая/последняя
    end
  end

  def create_train
    puts "Введите номер поезда:"
    number = gets.chomp
    puts "Тип поезда:\n1. Пассажирский\n2. Товарный"
    type = gets.to_i
    if type == 1
      @trains << PassengerTrain.new(number)
      puts "Пассажирский поезд #{number} создан!"
    elsif type == 2
      @trains << CargoTrain.new(number)
      puts "Грузовой поезд #{number} создан!"
    else
      puts "Неверно задан тип поезда."
    end
  end

  def add_car_to_train




  protected

  def station_exists?(name)
    @stations.key?(name)
  end

  def stations_not_enough?
    @stations.length <= 2
  end

  def route_choose_prompt
    puts "Выберите номер маршрута из списка:"
    i = 0
    loop do
      puts "#{i+1}. #{@routes[i].stations[0]} — #{@routes[i].stations[-1]}"
      i += 1
      break if i == @routes.length
    end
  end

end
