require_relative 'storage'
require_relative 'exceptions'

class Menu
  attr_reader :storage

  def initialize(storage)
    @storage = storage
    create_dummy_package
  end

  def execute
    loop do
      puts "\nВыберите действие:"
      puts '1. Управление станциями'
      puts '2. Управление маршрутами'
      puts '3. Конструктор поездов'
      puts '4. Управление поездами'
      puts '5. TEST: Полный список'
      puts '6. TEST: Валидации'
      puts '9. Выход'
      print '> '
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
        exhaustive_list
      when 6
        run_test_validations
      when 9
        exit
      else
        puts 'Неверный ввод.'
      end
    end
  end

  protected

  def entry_1
    puts "\nУПРАВЛЕНИЕ СТАНЦИЯМИ:"
    puts '1. Создать станцию'
    puts '2. Просмотреть все станции'
    puts '0. Вернуться назад'
    print '> '
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
    puts '1. Создать маршрут'
    puts '2. Просмотреть все маршруты'
    puts '3. Добавить станцию в маршрут'
    puts '4. Удалить станцию из маршрута'
    puts '0. Вернуться назад'
    print '> '
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
    puts '1. Создать поезд'
    puts '2. Добавить вагон в поезд'
    puts '3. Отцепить вагон от поезда'
    puts '4. Просмотреть существующие поезда'
    puts '5. Просмотреть все вагоны поезда'
    puts '6. Загрузить вагон поезда'
    puts '0. Вернуться назад'
    print '> '
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
    when 5
      see_train_cars
    when 6
      occupy_train_car
    else return
    end
  rescue Exceptions::NoObjects => err
    puts "#{err.message}\n"
    retry
  end

  def entry_4
    puts "\nУПРАВЛЕНИЕ ПОЕЗДАМИ:"
    puts '1. Присвоить маршрут поезду'
    puts '2. Переместить поезд вперёд по маршруту'
    puts '3. Переместить поезд назад по маршруту'
    puts '4. Просмотреть существующие поезда'
    puts '0. Вернуться назад'
    print '> '
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
    raise Exceptions::NoObjects, 'Список станций пуст.' if storage.stations.empty?
    puts 'Список станций:'
    storage.stations.each_value do |station|
      print station.name.to_s
      if station.trains == []
        print ", поездов нет.\n"
      else
        print "\n"
        station.each_train do |train|
          print '  Поезд ', train.info, "\n"
        end
      end
    end
  end

  def create_station
    print 'Введите название новой станции: '
    name = gets.chomp.capitalize
    if storage.station_exists?(name)
      puts "Станция с таким названием уже есть. Попробуйте \"#{name}-2\"."
    else
      storage.create_station(name)
      puts "Станция #{storage.stations[name].name} создана!"
    end
  end

  def create_route
    raise Exceptions::NoObjects, 'Недостаточно станций для создания маршрута.' if storage.stations_not_enough?
    puts 'Введите начальную станцию маршрута:'
    first_station = gets.chomp.capitalize
    raise 'такой станции нет' unless storage.station_exists?(first_station)
    puts 'Введите конечную станцию маршрута:'
    last_station = gets.chomp.capitalize
    raise 'такой станции нет' unless storage.station_exists?(last_station)
    storage.create_route(first_station, last_station)
    puts "Маршрут #{first_station} — #{last_station} создан."
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def add_station_to_route
    raise Exceptions::NoObjects, 'Ни одного маршрута ещё не создано.' if storage.routes.empty?
    raise Exceptions::NoObjects, 'Недостаточно станций для дополнения маршрута.' if storage.stations.length < 3
    route_choose_prompt
    print '> '
    input_num = gets.to_i - 1
    if storage.routes[input_num].assigned
      puts 'Маршрут уже назначен поезду, станции добавлять нельзя.'
    else
      puts 'Введите название новой станции в маршруте:'
      new_station = gets.chomp.capitalize # плюс проверки сущ-я станции
      puts 'Введите название станции, после которой следует добавить новую:'
      after_station = gets.chomp.capitalize # плюс проверки сущ-я станции
      storage.add_station_to_route(input_num, new_station, after_station)
      puts 'Станция добавлена в маршрут!'
    end
  rescue RuntimeError => err
    puts "#{err.message}\n"
    retry
  end

  def remove_station_from_route
    raise Exceptions::NoObjects, 'Ни одного маршрута ещё не создано.' if storage.routes.empty?
    route_choose_prompt
    print '> '
    input_num = gets.to_i - 1
    if storage.routes[input_num].assigned
      puts 'Маршрут уже назначен поезду, станции удалять нельзя.'
    elsif storage.routes[input_num].stations.length == 2
      puts 'В маршруте нет промежуточных станций, удалять нечего.'
    else
      puts 'Введите название удаляемой станции:'
      deleted_station = gets.chomp.capitalize
      storage.remove_station_from_route(input_num, deleted_station)
      puts 'Станция удалена!'
    end
  rescue RuntimeError => err
    puts "#{err.message}\n"
    retry
  end

  def create_train
    print "\nВведите номер поезда в формате XXX-XX или XXXXX (допустимы кириллица и цифры):\n> "
    train_number = gets.chomp
    print "\nТип поезда:\n1. Пассажирский\n2. Товарный\n> "
    type = gets.to_i
    type_string = %w[Пассажирский Товарный]
    case type
    when 1, 2
      storage.create_train(train_number, type)
      puts "#{type_string[type - 1]} поезд #{train_number} создан!"
    else
      raise 'неверно задан тип поезда'
    end
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def add_car_to_train
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    puts "Добавление вагона к поезду.\n"
    train_number = train_choose_prompt
    puts 'Введите название вагона:'
    car_name = gets.chomp
    puts 'Сколько таких вагонов следует прицепить?'
    cars_to_hook = gets.chomp.to_i
    raise 'введено некорректное количествов вагонов' if cars_to_hook < 1
    if storage.trains[train_number].is_a? PassengerTrain
      puts 'Введите количество мест в вагоне (или будет принято 100 по умолчанию)'
      car_capacity = gets.to_i
    else puts 'Введите вместимость вагона (или будет принято 100 по умолчанию)'
         car_capacity = gets.to_f
    end
    car_capacity = 100 if car_capacity == 0
    storage.add_car_to_train(train_number, car_name, cars_to_hook, car_capacity)
    puts 'Вагон прицеплен к поезду.' if cars_to_hook == 1
    puts 'Вагоны прицеплены к поезду.' if cars_to_hook > 1
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def remove_car_from_train
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    puts "Отцепка вагонов от поезда.\n"
    train_number = train_choose_prompt
    puts 'Сколько вагонов необходимо отцепить?'
    print '> '
    cars_to_remove = gets.chomp.to_i
    raise 'введено некорректное количествов вагонов' if cars_to_remove < 1
    storage.remove_car_from_train(train_number, cars_to_remove)
    puts 'Вагон отцеплен.' if cars_to_remove == 1
    puts 'Вагоны отцеплены.' if cars_to_remove > 1
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def see_trains
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    trains_list
  end

  def see_train_cars
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    puts "Просмотр всех вагонов поезда.\n"
    train_number = train_choose_prompt
    if storage.trains[train_number].cars.empty?
      puts 'В поезде пока нет вагонов'
    else
      list_all_train_cars(train_number)
    end
    puts ''
  end

  def occupy_train_car
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    puts "Загрузка вагона поезда.\n"
    train_number = train_choose_prompt
    if storage.trains[train_number].cars.empty?
      puts 'В поезде пока нет вагонов'
    else
      puts 'Выберите номер вагона из списка'
      list_all_train_cars(train_number)
      print "\n> "
      car_number = gets.to_i - 1
      raise 'выбран неверный номер вагона' unless car_number.between?(1, storage.trains[train_number].cars.length)
      if storage.trains[train_number].is_a? PassengerTrain
        print "\nСколько пассажиров посадить в вагон?\n> "
      else
        print "\nСколько объёма следует занять в вагоне?\n> "
      end
      occupation = gets.chomp
      storage.occupy_car(train_number, car_number, occupation)
    end
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def assign_route_to_train
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    route_choose_prompt
    print '> '
    input_num = gets.to_i - 1
    puts "\nПрисвоение маршрута поезду."
    train_number = train_choose_prompt
    storage.assign_route_to_train(train_number, input_num)
    puts "Маршрут присвоен поезду.\n"
  end

  def route_move_train_forward
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    raise Exceptions::NoObjects, 'Поездов на маршруте сейчас нет.' unless storage.routes.any?(&:assigned)
    puts "\nПеремещение поезда по маршруту."
    train_number = train_choose_prompt
    storage.route_move_train_forward(train_number)
    puts "Поезд перемещён вперёд по маршруту.\n"
  end

  def route_move_train_back
    raise Exceptions::NoObjects, 'Поезда пока не созданы.' if storage.trains.empty?
    raise Exceptions::NoObjects, 'Поездов на маршруте сейчас нет.' unless storage.routes.any?(&:assigned)
    puts "\nПеремещение поезда по маршруту."
    train_number = train_choose_prompt
    storage.route_move_train_back(train_number)
    puts "Поезд перемещён назад по маршруту.\n"
  end

  def route_choose_prompt
    raise Exceptions::NoObjects, 'Ни одного маршрута пока не создано.' unless storage.routes.any?
    puts 'Выберите номер маршрута из списка:'
    route_list
  end

  def route_list
    raise Exceptions::NoObjects, 'Ни одного маршрута пока не создано.' unless storage.routes.any?
    storage.routes.each.with_index(1) do |route, i|
      print "#{i}. #{route.stations.first.name} — #{route.stations.last.name}:"
      route.stations.each { |station| print " #{station.name}" }
      puts ''
    end
  end

  def train_choose_prompt
    puts "Выберите номер поезда из списка:\n\n"
    trains_list
    train_choose_input
  end

  def trains_list
    storage.trains.each.with_index(1) do |(_train_number, train), index|
      print "#{index}. ", train.info, "\n"
    end
  end

  def exhaustive_list
    puts ''
    storage.stations.each_value do |station|
      puts station.name.to_s
      station.each_train do |train|
        print '  Поезд ', train.info, "\n"
        train.each_car do |car|
          print "    #{car.index_number}.".ljust(8), "#{car.car_name}, #{car}. #{car.info}\n"
        end
      end
    end
    puts ''
  end

  protected

  def train_choose_input
    print '> '
    number = gets.chomp.to_i
    raise 'некорректный номер' if number < 1 || number > storage.trains.size
    number -= 1
    storage.trains.keys[number]
  rescue RuntimeError => err
    puts "Ошибка: #{err.message}. Попробуйте снова:\n"
    retry
  end

  def list_all_train_cars(train_number)
    puts ''
    storage.trains[train_number].each_car do |car|
      print "    #{car.index_number}.".ljust(8), "#{car.car_name}, #{car}. #{car.info}\n"
    end
  end

  def create_dummy_package
    station_set = %w[Москва Крюково Тверь Волочёк Бологое Угловка Санкт-Петербург]
    station_set.each { |name| storage.create_station(name) }
    storage.create_route('Москва', 'Санкт-Петербург')
    for i in 1..5 do
      storage.add_station_to_route(0, storage.stations.keys[i], storage.stations.keys[i - 1])
    end
    storage.create_route('Санкт-Петербург', 'Москва')
    storage.add_station_to_route(1, 'Бологое', 'Санкт-Петербург')
    storage.create_train('111-11', 1)
    storage.create_train('222-22', 2)
    storage.add_car_to_train('111-11', 'ПВ-1', 10)
    storage.add_car_to_train('222-22', 'ГВ-1', 20)
    storage.assign_route_to_train('111-11', 0)
    storage.assign_route_to_train('222-22', 1)
  end

  def run_test_validations
    puts "Валидация станций..."
    puts Station.validations
    storage.stations.each_value { |station| puts "#{station} #{station.name} #{station.name.class}, валидация: #{station.valid?}" }
    puts "\nВалидация поездов..."
    puts Train.validations
    storage.trains.each_value { |train| puts "#{train} #{train.number} #{train.valid?}" }
    puts "Валидация закончена"
  end
end
