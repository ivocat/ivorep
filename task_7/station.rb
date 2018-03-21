require_relative "instance_counter"

class Station
  attr_reader :trains, :name
  include InstanceCounter
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations << self
    register_instance
  end

  def accommodate(train)
    @trains << train
  end

  def depart(train)
    @trains.delete(train)
  end

  def trains_by_type(desired_type)
    @trains.select {|train| train.type == desired_type}
  end

  protected

  def validate!
    raise "вы не ввели имя станции" if name.empty?
  end
end
