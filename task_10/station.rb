require_relative 'instance_counter'
require_relative 'validation'

class Station
  attr_reader :trains, :name
  include InstanceCounter
  include Validation
  @@stations = []

  validate :name, :presence
  validate :name, :type, String

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate_name!
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
    @trains.select { |train| train.type == desired_type }
  end

  def each_train
    @trains.each { |train| yield train }
  end

  protected

  def validate_name!
    raise 'вы не ввели имя станции' if name.empty?
  end
end
