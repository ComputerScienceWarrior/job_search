require_relative 'version'

class JobSearch::Location
    @@all = []
    
    attr_accessor :state, :city, :link
    def initialize(state = nil, link = nil, city = nil)
        @state = state
        @link = link
        @city = city

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
