require 'colorize'

def get_states
    puts "Please select a State by it's corresponding number:".colorize(:green)
    sleep 3
    state = JobSearch::Scraper.state_selection
    input = gets.strip
    puts "You've selected the state " + "#{JobSearch::Location.all[input.to_i - 1].state.capitalize}!".colorize(:red)
    sleep 2
    return get_city_or_territory(JobSearch::Location.all[input.to_i - 1])
end
