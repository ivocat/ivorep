class Station
  
  @@trains_on_station = {}
  
  def initialize(station_name)
    @station_name = station_name
  end
  
  def acommodate(train_num, train_type)
    @train_instance = train_instance
    @train_type = train_type
    trains_on_station[@train_instance] = train_type
    puts "Train #{train_num} has arrived at the station."
  end
  
  def stationed_trains
    @@trains_on_station.each do |num, type|
      puts "List of trains on the station #{@station_name}:" if @@trains_on_station.length != 0
      puts "#{num}: #{type}"
    end
  end
  
  def stationed_trains_by_type(desired_type)
    @@trains_on_station.each do |num,type|
      puts num if type == desired_type #доделать
    end
  end
  
  def depart_train(train_num)
    @@trains_on_station.delete(train_num)
    puts "Train #{train_num}" has left the station.
    @@trains_on_station
  end
end

