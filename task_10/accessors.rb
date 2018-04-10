module Accessors
  def self.included(base)
    base.include InstanceMethods
  end

  module InstanceMethods
    def attr_accessor_with_history(*attr_names)
      attr_names.each do |attr_name|
        var_name = "@#{attr_name}".to_sym

        define_method(attr_name) { instance_variable_get(var_name) }

        define_method("#{attr_name}_history".to_sym) do
          instance_variable_get("@#{attr_name}_history") || []
        end

        define_method("#{attr_name}=".to_sym) do |value|
          arr = instance_variable_get("@#{attr_name}_history")
          arr ||= []
          arr << new_value
          instance_variable_set("@#{attr_name}_history", arr)
          instance_variable_set("@#{attr_name}", value)
        end
      end
    end

    def strong_attr_accessor(attr_name, attr_klass)
      var_name = "@#{attr_name}".to_sym

      define_method(attr_name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value) if value.is_a?(@attr_klass) #???
      end
    end
  end

end
