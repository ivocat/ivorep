require_relative "station"
require_relative "route"
require_relative "cargo_car"
require_relative "cargo_train"
require_relative "passenger_car"
require_relative "passenger_train"

class Controller
  def initialize
    @stations = {}
    @trains = {}
    @routes = []
    @cars = {}
  end

  def stations_list
    if @stations.empty?
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
            if index < station.trains.size - 1
              print "#{train.number}, "
            else
              print "#{train.number}."
            end
          end
          puts ""
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
    @routes << Route.new(@stations[first_station], @stations[last_station])
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
      input_num = gets.to_i -1
      if @routes[input_num].assigned
        puts "Маршрут уже назначен поезду, станции добавлять нельзя."
      else
        puts "Введите название новой станции в маршруте:"
        new_station = gets.chomp.capitalize #плюс проверки сущ-я станции
        puts "Введите название станции, после которой следует добавить новую:"
        after_station = gets.chomp.capitalize #плюс проверки сущ-я станции
        @routes[input_num].add_train_stop(@stations[new_station], @stations[after_station])
        puts "Станция добавлена в маршрут!"
      end
    end
  end

  def remove_station_from_route
    if @routes.empty?
      puts "Ни одного маршрута ещё не создано."
    else
      route_choose_prompt
      print "> "
      input_num = gets.to_i
      if @routes[input_num - 1].assigned == false
        puts "Введите название удаляемой станции:"
        deleted_station = gets.chomp.capitalize
        @routes[input_num - 1].remove_train_stop(@stations[deleted_station])
        puts "Станция удалена!" #может и не удалена, если первая/последняя
      else
        puts "Маршрут уже назначен поезду, станции удалять нельзя."
      end
    end
  end

  def create_train
    puts "Введите номер поезда:"
    number = gets.chomp
    puts "Тип поезда:\n1. Пассажирский\n2. Товарный"
    type = gets.to_i
    case type
    when 1
      @trains[number] = PassengerTrain.new(number)
      puts "Пассажирский поезд #{number} создан!"
    when 2
      @trains[number] = CargoTrain.new(number)
      puts "Грузовой поезд #{number} создан!"
    else
      puts "Неверно задан тип поезда."
    end
  end

  def add_car_to_train
    puts "Введите номер поезда, к которому следует прицепить вагон:"
    number = gets.chomp
    unless @trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    puts "Введите название вагона:"
    car_name = gets.chomp
    if @trains[number].is_a?(PassengerTrain)
      @cars[car_name] = PassengerCar.new
      @trains[number].car_add(@cars[car_name])
    else
      @cars[car_name] = CargoCar.new
      @trains[number].car_add(@cars[car_name])
    end
    puts "Вагон прицеплен к поезду."
  end

  def remove_car_from_train
    puts "Введите номер поезда, от которого следует отцепить вагон:"
    number = gets.chomp
    unless @trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    @trains[number].car_remove
  end

  def assign_route_to_train
    if @trains.empty?
      puts "Поезда пока не созданы."
      return
    end
    route_choose_prompt
    print "> "
    input_num = gets.to_i
    puts "Введите номер поезда, которому следует присвоить маршрут:"
    number = gets.chomp
    @trains[number].route(@routes[input_num - 1])
  end

  def route_move_train_forward
    puts "Введите номер перемещаемого поезда:"
    number = gets.chomp
    @trains[number].move_forward
  end

  def route_move_train_back
    puts "Введите номер перемещаемого поезда:"
    number = gets.chomp
    @trains[number].move_back
  end

  def route_list
    @routes.each_with_index do |route, i|
      print "#{i+1}. #{route[i].stations[first].name} — #{route[i].stations[last].name}:"
      route[i].stations.each {|station| print " #{station.name}"}
      puts ""
    end
  end

  protected

  def station_exists?(name)
    @stations.key?(name)
  end

  def stations_not_enough?
    @stations.length < 2
  end

  def route_choose_prompt
    puts "Выберите номер маршрута из списка:"
    route_list
  end

end
