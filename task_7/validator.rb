module Validator
  def valid?
    validate!
    true
  rescue
    false
  end

  def validate!
    raise NotImplementedError, "Метод определения валидности не задан"
  end
end
