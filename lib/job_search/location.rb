require_relative 'version'

class JobSearch::Location
    @@all = []
    
    attr_accessor :state, :city
    def initialize(state = nil, city = nil, link = nil)
        @state = state
        @city = city
        @link = link

        @@all << self 
    end

    def self.all
        @@all
    end

    def self.destroy
        @@all.clear
    end

    def self.first
        @@all[0]
    end

    def self.last
        @@all[@@all.count - 1]
    end
    
end
