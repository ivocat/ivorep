require_relative "storage"
require_relative "exceptions"

class Menu
  attr_reader :storage

  def initialize (storage)
    @storage = storage
    create_dummy_package
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
  rescue Exceptions::NoObjects => err
    puts "#{err.message}\n"
    retry
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
  rescue Exceptions::NoObjects => err
    puts "#{err.message}\n"
    retry
  end
  def entry_3
    puts "\nКОНСТРУКТОР ПОЕЗДОВ:"
    puts "1. Создать поезд"
    puts "2. Добавить вагон в поезд"
    puts "3. Отцепить вагон от поезда"
    puts "4. Просмотреть существующие поезда"
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
    when 4
      see_trains
    else return
    end
  rescue Exceptions::NoObjects => err
    puts "#{err.message}\n"
    retry
  end
  def entry_4
    puts "\nУПРАВЛЕНИЕ ПОЕЗДАМИ:"
    puts "1. Присвоить маршрут поезду"
    puts "2. Переместить поезд вперёд по маршруту"
    puts "3. Переместить поезд назад по маршруту"
    puts "4. Просмотреть существующие поезда"
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
    when 4
      see_trains
    else return
    end
  rescue Exceptions::NoObjects => err
    puts "#{err.message}\n"
    retry
  end

  def stations_list
    raise Exceptions::NoObjects, "Список станций пуст." if storage.stations.empty?
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
    raise Exceptions::NoObjects, "Недостаточно станций для создания маршрута." if storage.stations_not_enough?
    puts "Введите начальную станцию маршрута:"
    first_station = gets.chomp.capitalize
    unless storage.station_exists?(first_station)
      raise "такой станции нет"
    end
    puts "Введите конечную станцию маршрута:"
    last_station = gets.chomp.capitalize
    unless storage.station_exists?(last_station)
      raise "такой станции нет"
    end
    storage.create_route(first_station, last_station)
    puts "Маршрут #{first_station} — #{last_station} создан."
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def add_station_to_route
    raise Exceptions::NoObjects, "Ни одного маршрута ещё не создано." if storage.routes.empty?
    raise Exceptions::NoObjects, "Недостаточно станций для дополнения маршрута." if storage.stations.length < 3
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

  def remove_station_from_route
    raise Exceptions::NoObjects, "Ни одного маршрута ещё не создано." if storage.routes.empty?
    route_choose_prompt
    print "> "
    input_num = (gets.to_i) - 1
    if storage.routes[input_num].assigned
      puts "Маршрут уже назначен поезду, станции удалять нельзя."
    elsif storage.routes[input_num].stations.length == 2
      puts "В маршруте нет промежуточных станций, удалять нечего."
    else
      puts "Введите название удаляемой станции:"
      deleted_station = gets.chomp.capitalize
      storage.remove_station_from_route(input_num,deleted_station)
      puts "Станция удалена!"
    end
  rescue RuntimeError => err
    puts "#{err.message}\n"
    retry
  end

  def create_train
    print "\nВведите номер поезда в формате XXX-XX или XXXXX (допустимы кириллица и цифры):\n> "
    number = gets.chomp
    print "\nТип поезда:\n1. Пассажирский\n2. Товарный\n> "
    type = gets.to_i
    type_string = ["Пассажирский", "Товарный"]
    case type
    when 1,2
      storage.create_train(number,type)
      puts "#{type_string[type - 1]} поезд #{number} создан!"
    else
      raise "неверно задан тип поезда"
    end
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def add_car_to_train
    raise Exceptions::NoObjects, "Поезда пока не созданы." if storage.trains.empty?
    puts "Добавление вагона к поезду.\n"
    number = train_choose_prompt
    puts "Введите название вагона:"
    car_name = gets.chomp
    puts "Сколько таких вагонов следует прицепить?"
    cars_to_hook = gets.chomp.to_i
    raise "введено некорректное количествов вагонов" if cars_to_hook < 1
    storage.add_car_to_train(number,car_name,cars_to_hook)
    puts "Вагон прицеплен к поезду." if cars_to_hook == 1
    puts "Вагоны прицеплены к поезду." if cars_to_hook > 1
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def remove_car_from_train
    raise Exceptions::NoObjects, "Поезда пока не созданы." if storage.trains.empty?
    puts "Отцепка вагонов от поезда.\n"
    number = train_choose_prompt
    puts "Сколько вагонов необходимо отцепить?"
    print "> "
    cars_to_remove = gets.chomp.to_i
    raise "введено некорректное количествов вагонов" if cars_to_remove < 1
    storage.remove_car_from_train(number,cars_to_remove)
    puts "Вагон отцеплен." if cars_to_remove == 1
    puts "Вагоны отцеплены." if cars_to_remove > 1
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def see_trains
    raise Exceptions::NoObjects, "Поезда пока не созданы." if storage.trains.empty?
    trains_list
  end

  def assign_route_to_train
    raise Exceptions::NoObjects, "Поезда пока не созданы." if storage.trains.empty?
    route_choose_prompt
    print "> "
    input_num = (gets.to_i) - 1
    puts "\nПрисвоение маршрута поезду."
    number = train_choose_prompt
    storage.assign_route_to_train(number,input_num)
    puts "Маршрут присвоен поезду.\n"
  end

  def route_move_train_forward
    raise Exceptions::NoObjects, "Поезда пока не созданы." if storage.trains.empty?
    raise Exceptions::NoObjects, "Поездов на маршруте сейчас нет." unless storage.routes.any? {|route| route.assigned}
    puts "\nПеремещение поезда по маршруту."
    number = train_choose_prompt
    storage.route_move_train_forward(number)
    puts "Поезд перемещён вперёд по маршруту.\n"
  end

  def route_move_train_back
    raise Exceptions::NoObjects, "Поезда пока не созданы." if storage.trains.empty?
    raise Exceptions::NoObjects, "Поездов на маршруте сейчас нет." unless storage.routes.any? {|route| route.assigned}
    puts "\nПеремещение поезда по маршруту."
    number = train_choose_prompt
    storage.route_move_train_back(number)
    puts "Поезд перемещён назад по маршруту.\n"
  end

  def route_choose_prompt
    raise Exceptions::NoObjects, "Ни одного маршрута пока не создано." unless storage.routes.any?
    puts "Выберите номер маршрута из списка:"
    route_list
  end

  def route_list
    raise Exceptions::NoObjects, "Ни одного маршрута пока не создано." unless storage.routes.any?
    storage.routes.each.with_index(1) do |route, i|
      print "#{i}. #{route.stations.first.name} — #{route.stations.last.name}:"
      route.stations.each {|station| print " #{station.name}"}
      puts ""
    end
  end

  def train_choose_prompt
    puts "Выберите номер поезда из списка:\n\n"
    trains_list
    train_choose_input
  end

  def trains_list
    storage.trains.each.with_index(1) do |(number, train), index|
      print "#{index}. #{number}".ljust(10) , "— "
      print "#{train.class.to_s}.".ljust(14)
      print "Вагонов нет." if train.cars.empty?
      print "Вагонов: #{train.cars.length}." if train.cars.any?
      puts ""
    end
  end
  
  def exhaustive_list
    storage.stations.each_value do |station|
      puts station.name
      station.iterate_trains(block_trains)
      puts ""
    end
  end

  protected

  def train_choose_input
    print "> "
    number = gets.chomp.to_i
    raise "некорректный номер" if number < 1 || number > storage.trains.size
    number -= 1
    storage.trains.keys[number]
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def create_dummy_package
    station_set = %w(Москва Крюково Тверь Волочёк Бологое Угловка Санкт-Петербург)
    station_set.each {|name| storage.create_station(name)}
    storage.create_route("Москва","Санкт-Петербург")
    for i in 1..5 do
      storage.add_station_to_route(0,storage.stations.keys[i],storage.stations.keys[i - 1])
    end
    storage.create_route("Санкт-Петербург","Москва")
    storage.add_station_to_route(1,"Бологое","Санкт-Петербург")
    storage.create_train("111-11",1)
    storage.create_train("222-22",2)
    storage.add_car_to_train("111-11","ПВ-1",10)
    storage.add_car_to_train("222-22","ГВ-1",20)
    storage.assign_route_to_train("111-11",0)
    storage.assign_route_to_train("222-22",1)
  end
end
