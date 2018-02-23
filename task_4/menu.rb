require_relative "controller"

class Menu

  def initialize (controller)
    @controller = controller
  end

  def execute
    puts "Выберите действие:"
    puts "1. Управление станциями
    2. Создание маршрутов
    3. Конструктор поездов
    4. Управление поездами
    5. Выход"

    input = gets.to_i

    case input
    when 1
      puts "1. Просмотреть все станции
      2. Создать станцию
      0. Вернуться назад"
      #создать станцию нельзя, если имя уже занято
      input_sub = gets.to_i
      case input_sub
      when 1
        controller.stations_list
      when 2
        controller.create_station
      else #go back
      end
    when 2
      puts "1. Создать маршрут
      2. Добавить станцию в маршрут
      3. Удалить станцию из маршрута
      0. Вернуться назад"
      #создать маршрут нельзя, если станций не хватает
      #добавить станцию нельзя, если станций нет
      #станцию нельзя удалить, если на ней поезд
      input_sub = gets.to_i
      case input_sub
      when 1
        exit #do_1
      when 2
        exit #do_2
      when 3
        exit #do_3
      else
        exit #go back
      end
    when 3
      puts "1. Создать поезд
      2. Добавить вагон в поезд
      3. Отцепить вагон от поезда
      0. Вернуться назад"
      input_sub = gets.to_i
      case input_sub
      when 1
        exit #do_1
      when 2
        exit #do_2
      when 3
        exit #do_3
      else
        exit #go back
      end
    when 4
      puts "1. Присвоить маршрут поезду
      2. Переместить поезд вперёд по маршруту
      3. Переместить поезд назад по маршруту
      0. Вернуться назад"
      input_sub = gets.to_i
      case input_sub
      when 1
        exit #do_1
      when 2
        exit #do_2
      when 3
        exit #do_3
      else #go back
      end
    when 5
      exit
    else
      puts "Неверный ввод."
    end
  end

end
