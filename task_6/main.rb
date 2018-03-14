require_relative "storage"
require_relative "menu"

storage = Storage.new
menu = Menu.new(storage)

menu.execute
