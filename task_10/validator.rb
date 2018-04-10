module Validator
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def validate!
    raise NotImplementedError, 'Метод определения валидности не задан'
  end
end
