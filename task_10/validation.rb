module Validation
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    def validate(attr_name, validation_type, arg = nil)
      false
      case validation_type
      when :presence
        true if attr_name != "" && !attr_name.nil?
      when :format
        true if attr_name =~ /#{Regexp.quote(arg)}/
        true if attr_name =~ args.first #necessary?
      when :type
        true if attr_name.is_a?(*arg)
      else
        raise "Неверный тип проверки"
      end
    end
  end
  
  module InstanceMethods
    def validate!
      self.class.validate #to be completed
    end
    
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end
