require 'colorize'

def error_message
    puts "Sorry, that's not valid input, please try again.".upcase.colorize(:red)
end
