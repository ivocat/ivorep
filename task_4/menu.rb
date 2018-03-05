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
          controller.create_station
        when 2
          controller.stations_list
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
          controller.create_route
        when 2
          controller.route_list
        when 3
          controller.add_station_to_route
        when 4
          controller.remove_station_from_route
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
          controller.create_train
        when 2
          controller.add_car_to_train
        when 3
          controller.remove_car_from_train
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
          controller.assign_route_to_train
        when 2
          controller.route_move_train_forward
        when 3
          controller.route_move_train_back
        else #go back
        end
      when 5
        exit
      else
        puts "Неверный ввод."
      end
    end
  end

end
