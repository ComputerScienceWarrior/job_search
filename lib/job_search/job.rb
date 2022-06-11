require_relative 'version'

class JobSearch::Job
    @@all = []
    
    attr_accessor :title, :date, :compensation, :employment_type, :body, :link, :category
    def initialize(title = nil, compensation = nil, employment_type = nil, body = nil)
        @title = title
        @date = date
        @compensation = compensation 
        @employment_type = employment_type
        @body = body
        @category = category

        @@all << self 
    end

    def descriptor
        puts "Job title:        #{self.title}".colorize(:red)
        puts "Job post-date:    #{self.date}".colorize(:red)
        puts "Job compensation: #{self.compensation}".colorize(:green)
        puts "Employment type: #{self.employment_type}".colorize(:green)
        puts "Job Description:  #{self.body}".colorize(:blue)
    end

    def self.all
        @@all
    end

    def self.destroy
        @@all.clear
    end
end
