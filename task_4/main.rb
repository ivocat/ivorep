require_relative "controller"
require_relative "menu"

controller = Controller.new
menu = Menu.new(controller)

menu.execute
