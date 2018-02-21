require_relative "station"
require_relative "route"
require_relative "station"
require_relative "train"
require_relative "train_car"
require_relative "cargo_car"
require_relative "cargo_train"
require_relative "passenger_car"
require_relative "passenger_train"
require_relative "menu"

menu = Menu.new

loop do
  menu.execute
end
