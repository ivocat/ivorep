module Validation
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(attribute_name, validation_type, arg = nil)
      @validations ||= {}
      @validations[attribute_name] ||= []
      @validations[attribute_name] << {validation_type: validation_type, arg: arg}
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
      self.class.validations.each do |attribute_name, validation_array|
        validation_array.each do |validation_hash|
          begin
            case validation_hash[:validation_type]
            when :presence
              validate_presence(attribute_name, self.instance_variable_get("@#{attribute_name}"))
            when :format
              validate_format(attribute_name, self.instance_variable_get("@#{attribute_name}"), validation_hash[:arg])
            when :type
              validate_type(attribute_name, self.instance_variable_get("@#{attribute_name}"), validation_hash[:arg])
            else
              raise "неправильно задана валидация: #{validation_type}, параметр: #{arg}"
            end
          # rescue RuntimeError => err
          #   print "\nВалидация атрибута #{attribute_name} у ", self.instance_variable_get("@#{attribute_name}"), " не прошла: #{err.message}."
          end
        end
      end
    end

    def validate_presence(attribute_name, attribute)
      raise "атрибут #{attribute_name} не существует или пуст" if attribute == "" || attribute.nil?
    end

    def validate_format(attribute_name, attribute, arg)
      raise "неправильный формат атрибута #{attribute_name} ('#{attribute}')" if attribute !~ arg
    end

    def validate_type(attribute_name, attribute, arg)
      raise "класс атрибута #{attribute_name} не #{arg}" if !attribute.is_a?(arg)
    end
  end
end
