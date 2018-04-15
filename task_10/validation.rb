module Validation
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(attr_name, validation_type, arg = nil)
      @validations ||= {}
      @validations[attr_name] ||= []
      @validations[attr_name] << {validation_type: validation_type, arg: arg}
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError => e
      puts "не прошла — #{e.message}"
      false
    end

    protected

    def validate!
      self.class.validations.each do |attr_name, validation_array|
        validation_array.each do |validation_hash|
          begin
            case validation_hash[:validation_type]
            when :presence
              validate_presence(self.instance_variable_get("@#{attr_name}"))
            when :format
              validate_format(self.instance_variable_get("@#{attr_name}"), validation_hash[:arg])
            when :type
              validate_type(self.instance_variable_get("@#{attr_name}"), validation_hash[:arg])
            else
              raise "неправильно задана валидация: #{validation_type}, параметр: #{arg}"
            end
          # rescue RuntimeError => err
          #   print "\nВалидация атрибута #{attr_name} у ", self.instance_variable_get("@#{attr_name}"), " не прошла: #{err.message}."
          end
        end
      end
    end

    def validate_presence(attribute)
      raise "атрибут не существует или пуст" if attribute == "" || attribute.nil?
    end

    def validate_format(attribute, arg)
      raise "неправильный формат атрибута" if attribute !~ arg
    end

    def validate_type(attribute, arg)
      raise "класс атрибута не #{arg}" if !attribute.is_a?(arg)
    end
  end
end
