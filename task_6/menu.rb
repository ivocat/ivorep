require_relative "storage"

class Menu
  attr_reader :storage

  def initialize (storage)
    @storage = storage
  end

  def execute
    loop do
      puts "\nВыберите действие:"
      puts "1. Управление станциями"
      puts "2. Управление маршрутами"
      puts "3. Конструктор поездов"
      puts "4. Управление поездами"
      puts "5. Выход"
      print "> "
      input = gets.to_i

      case input
      when 1
        entry_1
      when 2
        entry_2
      when 3
        entry_3
      when 4
        entry_4
      when 5
        exit
      else
        puts "Неверный ввод."
      end
    end
  end

  protected

  def entry_1
    puts "\nУПРАВЛЕНИЕ СТАНЦИЯМИ:"
    puts "1. Создать станцию"
    puts "2. Просмотреть все станции"
    puts "0. Вернуться назад"
    print "> "
    input_sub = gets.to_i
    puts "\n"
    case input_sub
    when 1
      create_station
    when 2
      stations_list
    else return
    end
  end
  def entry_2
    puts "\nУПРАВЛЕНИЕ МАРШРУТАМИ:"
    puts "1. Создать маршрут"
    puts "2. Просмотреть все маршруты"
    puts "3. Добавить станцию в маршрут"
    puts "4. Удалить станцию из маршрута"
    puts "0. Вернуться назад"
    print "> "
    #создать маршрут нельзя, если станций не хватает
    #добавить станцию нельзя, если станций нет
    #станцию нельзя удалить, если на ней поезд
    input_sub = gets.to_i
    puts "\n"
    case input_sub
    when 1
      create_route
    when 2
      route_list
    when 3
      add_station_to_route
    when 4
      remove_station_from_route
    else return
    end
  end
  def entry_3
    puts "\nКОНСТРУКТОР ПОЕЗДОВ:"
    puts "1. Создать поезд"
    puts "2. Добавить вагон в поезд"
    puts "3. Отцепить вагон от поезда"
    puts "0. Вернуться назад"
    print "> "
    input_sub = gets.to_i
    puts "\n"
    case input_sub
    when 1
      create_train
    when 2
      add_car_to_train
    when 3
      remove_car_from_train
    else return
    end
  end
  def entry_4
    puts "\nУПРАВЛЕНИЕ ПОЕЗДАМИ:"
    puts "1. Присвоить маршрут поезду"
    puts "2. Переместить поезд вперёд по маршруту"
    puts "3. Переместить поезд назад по маршруту"
    puts "0. Вернуться назад"
    print "> "
    input_sub = gets.to_i
    puts "\n"
    case input_sub
    when 1
      assign_route_to_train
    when 2
      route_move_train_forward
    when 3
      route_move_train_back
    else return
    end
  end

  def stations_list
    if storage.stations.empty?
      puts "Список станций пуст."
    else
      puts "Список станций:"
      storage.stations.each_value do |station|
        print "#{station.name}"
        if station.trains == []
          print ", поездов нет.\n"
        else
          print ", поезда: "
          station.trains[0..-2].each do |train|
            print "#{train.number}, "
          end
          print "#{station.trains.last.number}.\n"
        end
      end
    end
  end

  def create_station
    print "Введите название новой станции: "
    name = gets.chomp.capitalize
    if storage.station_exists?(name)
      puts "Станция с таким названием уже есть. Попробуйте \"#{name}-2\"."
    else
      storage.create_station(name)
      puts "Станция #{storage.stations[name].name} создана!"
    end
  end

  def create_route
    if storage.stations_not_enough?
      puts "Недостаточно станций для создания маршрута."
      return
    end
    puts "Введите начальную станцию маршрута:"
    first_station = gets.chomp.capitalize
    unless storage.station_exists?(first_station)
      puts "Такой станции нет!"
      return
    end
    puts "Введите конечную станцию маршрута:"
    last_station = gets.chomp.capitalize
    unless storage.station_exists?(last_station)
      puts "Такой станции нет!"
      return
    end
    storage.create_route(first_station, last_station)
    puts "Маршрут #{first_station} — #{last_station} создан."
  end

  def add_station_to_route
    if storage.routes.empty?
      puts "Ни одного маршрута ещё не создано."
    elsif storage.stations_not_enough?
      puts "Недостаточно станций для дополнения маршрута."
    else
      route_choose_prompt
      print "> "
      input_num = (gets.to_i) - 1
      if storage.routes[input_num].assigned
        puts "Маршрут уже назначен поезду, станции добавлять нельзя."
      else
        puts "Введите название новой станции в маршруте:"
        new_station = gets.chomp.capitalize #плюс проверки сущ-я станции
        puts "Введите название станции, после которой следует добавить новую:"
        after_station = gets.chomp.capitalize #плюс проверки сущ-я станции
        storage.add_station_to_route(input_num,new_station,after_station)
        puts "Станция добавлена в маршрут!"
      end
    end
  end

  def remove_station_from_route
    if storage.routes.empty?
      puts "Ни одного маршрута ещё не создано."
    else
      route_choose_prompt
      print "> "
      input_num = (gets.to_i) - 1
      if storage.routes[input_num].assigned
        puts "Маршрут уже назначен поезду, станции удалять нельзя."
      else
        puts "Введите название удаляемой станции:"
        deleted_station = gets.chomp.capitalize
        storage.remove_station_from_route(input_num,deleted_station)
        puts "Станция удалена!" #может и не удалена, если первая/последняя
      end
    end
  end

  def create_train
    puts "Введите номер поезда:"
    number = gets.chomp
    puts "Тип поезда:\n1. Пассажирский\n2. Товарный"
    type = gets.to_i
    type_string = ["Пассажирский", "Товарный"]
    case type
    when 1,2
      storage.create_train(number,type)
      puts "#{type_string[type - 1]} поезд #{number} создан!"
    else
      puts "Неверно задан тип поезда."
    end
  end

  def add_car_to_train
    puts "Введите номер поезда, к которому следует прицепить вагон:"
    number = gets.chomp
    unless storage.trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    puts "Введите название вагона:"
    car_name = gets.chomp
    storage.add_car_to_train(number,car_name)
    puts "Вагон прицеплен к поезду."
  end

  def remove_car_from_train
    puts "Введите номер поезда, от которого следует отцепить вагон:"
    number = gets.chomp
    unless storage.trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    storage.remove_car_from_train(number)
    puts "Вагон отцеплен."
  end

  def assign_route_to_train
    if storage.trains.empty?
      puts "Поезда пока не созданы."
      return
    end
    route_choose_prompt
    print "> "
    input_num = (gets.to_i) - 1
    puts "Введите номер поезда, которому следует присвоить маршрут:"
    number = gets.chomp
    storage.assign_route_to_train(number,input_num)
  end

  def route_move_train_forward
    puts "Введите номер перемещаемого поезда:"
    number = gets.chomp
    unless storage.trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    storage.route_move_train_forward(number)
  end

  def route_move_train_back
    puts "Введите номер перемещаемого поезда:"
    number = gets.chomp
    unless storage.trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    storage.route_move_train_back(number)
  end

  def route_list
    storage.routes.each.with_index(1) do |route, i|
      print "#{i}. #{route.stations.first.name} — #{route.stations.last.name}:"
      route.stations.each {|station| print " #{station.name}"}
      puts ""
    end
  end

  def route_choose_prompt
    puts "Выберите номер маршрута из списка:"
    route_list
  end

end
