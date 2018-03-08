require_relative "controller"

class Menu
  attr_reader :controller

  def initialize (controller)
    @controller = controller
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
        else #go back
        end
      when 2
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
        else #go back
        end
      when 3
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
        else #go back
        end
      when 4
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
        else #go back
        end
      when 5
        exit
      else
        puts "Неверный ввод."
      end
    end
  end

  protected

  def stations_list
    if controller.stations.empty?
      puts "Список станций пуст."
    else
      puts "Список станций:"
      controller.stations.each_value do |station|
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
    if controller.station_exists?(name)
      puts "Станция с таким названием уже есть. Попробуйте \"#{name}-2\"."
    else
      controller.create_station(name)
      puts "Станция #{controller.stations[name].name} создана!"
    end
  end

  def create_route
    if controller.stations_not_enough?
      puts "Недостаточно станций для создания маршрута."
      return
    end
    puts "Введите начальную станцию маршрута:"
    first_station = gets.chomp.capitalize
    unless controller.station_exists?(first_station)
      puts "Такой станции нет!"
      return
    end
    puts "Введите конечную станцию маршрута:"
    last_station = gets.chomp.capitalize
    unless controller.station_exists?(last_station)
      puts "Такой станции нет!"
      return
    end
    controller.create_route(first_station, last_station)
    puts "Маршрут #{first_station} — #{last_station} создан."
  end

  def add_station_to_route
    if controller.routes.empty?
      puts "Ни одного маршрута ещё не создано."
    elsif controller.stations_not_enough?
      puts "Недостаточно станций для дополнения маршрута."
    else
      route_choose_prompt
      print "> "
      input_num = (gets.to_i) - 1
      if controller.routes[input_num].assigned
        puts "Маршрут уже назначен поезду, станции добавлять нельзя."
      else
        puts "Введите название новой станции в маршруте:"
        new_station = gets.chomp.capitalize #плюс проверки сущ-я станции
        puts "Введите название станции, после которой следует добавить новую:"
        after_station = gets.chomp.capitalize #плюс проверки сущ-я станции
        controller.add_station_to_route(input_num,new_station,after_station)
        puts "Станция добавлена в маршрут!"
      end
    end
  end

  def remove_station_from_route
    if controller.routes.empty?
      puts "Ни одного маршрута ещё не создано."
    else
      route_choose_prompt
      print "> "
      input_num = (gets.to_i) - 1
      if controller.routes[input_num].assigned == false
        puts "Введите название удаляемой станции:"
        deleted_station = gets.chomp.capitalize
        controller.remove_station_from_route(input_num,deleted_station)
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
    type_string = ["Пассажирский", "Товарный"]
    case type
    when 1,2
      controller.create_train(number,type)
      puts "#{type_string[type - 1]} поезд #{number} создан!"
    else
      puts "Неверно задан тип поезда."
    end
  end

  def add_car_to_train
    puts "Введите номер поезда, к которому следует прицепить вагон:"
    number = gets.chomp
    unless controller.trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    puts "Введите название вагона:"
    car_name = gets.chomp
    controller.add_car_to_train(number,car_name)
    puts "Вагон прицеплен к поезду."
  end

  def remove_car_from_train
    puts "Введите номер поезда, от которого следует отцепить вагон:"
    number = gets.chomp
    unless controller.trains.key?(number)
      puts "Такого поезда нет."
      return
    end
    controller.remove_car_from_train(number)
    puts "Вагон отцеплен."
  end

  def assign_route_to_train
    if controller.trains.empty?
      puts "Поезда пока не созданы."
      return
    end
    route_choose_prompt
    print "> "
    input_num = (gets.to_i) - 1
    puts "Введите номер поезда, которому следует присвоить маршрут:"
    number = gets.chomp
    controller.assign_route_to_train(number,input_num)
  end

  def route_move_train_forward
    puts "Введите номер перемещаемого поезда:"
    number = gets.chomp
    controller.route_move_train_forward(number)
  end

  def route_move_train_back
    puts "Введите номер перемещаемого поезда:"
    number = gets.chomp
    controller.route_move_train_back(number)
  end

  def route_list
    controller.routes.each_with_index do |route, i|
      print "#{i+1}. #{route.stations.first.name} — #{route.stations.last.name}:"
      route.stations.each {|station| print " #{station.name}"}
      puts ""
    end
  end

  def route_choose_prompt
    puts "Выберите номер маршрута из списка:"
    route_list
  end

end
