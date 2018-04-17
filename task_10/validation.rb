module Validation
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    attr_accessor :latest_error

    def validate(attribute_name, validation_type, arg = nil)
      @validations ||= {}
      @validations[attribute_name] ||= []
      @validations[attribute_name] << {validation_type: validation_type, arg: arg}
    end

    def validations
      instance_variable_get("@validations") || {}
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue NoMethodError, RuntimeError => e
      self.class.latest_error = e
      false
    end

    protected

    def validate!
      self.class.validations.each do |attribute_name, validation_array|
        attribute = self.instance_variable_get("@#{attribute_name}")
        validation_array.each do |validation_hash|
          self.send("validate_#{validation_hash[:validation_type]}", \
                    attribute_name, \
                    attribute, \
                    validation_hash[:arg])
        end
      end
    end

    def validate_presence(attribute_name, attribute, _ = nil)
      raise "атрибут #{attribute_name} не существует или пуст" if attribute.to_s.empty?
    end

    def validate_format(attribute_name, attribute, string_format)
      raise "неправильный формат атрибута #{attribute_name} ('#{attribute}')" if attribute !~ string_format
    end

    def validate_type(attribute_name, attribute, klass)
      raise "класс атрибута #{attribute_name} не #{klass}" unless attribute.is_a?(klass)
    end
  end
end
