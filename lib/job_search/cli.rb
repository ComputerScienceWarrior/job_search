require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative 'prompts'
require_relative 'error'
require_relative 'get_states'
require_relative 'version'

class JobSearch::CLI 

    def program_run
        site_to_scrape = greeting
        create_and_display_categories site_to_scrape
        user_category_selection 
        create_and_display_all_job_listings
        user_job_selection 
        view_another_job_or_category?
    end

    def get_city_or_territory(state_territory)
        city = JobSearch::Scraper.city_territory_scraper state_territory
        puts "Which location in #{state_territory.state} would you like to browse for jobs?".colorize(:green)
        sleep 2

         if city.kind_of?(Array)
            city.each {|city| puts "#{city}" }
            input = gets.chomp
            selection = city[input.to_i - 1]
         end

         return selection
    end

    def create_and_display_categories(site_to_scrape)
        categories = JobSearch::Scraper.scrape_site(site_to_scrape) #store site data in categories variable
        JobSearch::Category.all.each.with_index(1) {|category, index| puts "#{index}. #{category.category_name}"}
    end   

    def user_category_selection
        input = gets.strip

        if  (1..JobSearch::Category.all.size).include?(input.to_i)
            puts "You've selected the category " + "#{JobSearch::Category.all[input.to_i - 1].category_name}!".colorize(:red)
            
            sleep 2
            JobSearch::Scraper.scrape_category_for_job_links(JobSearch::Category.all[input.to_i - 1].link) #scrape this
        else
            error_message
            which_category_prompt
            user_category_selection
        end
    end

    def create_and_display_all_job_listings
        which_job_info?
        JobSearch::Category.jobs.each.with_index(1) { |j, index| puts "#{index}. #{j.split("/d/").last.split('/').first}" }
    end

    def user_job_selection
        input = gets.strip.downcase
        
        if (1..JobSearch::Category.jobs.size).include? input.to_i 
            puts "Here is the job link if you'd like to view the job page: " + "#{JobSearch::Category.jobs[input.to_i - 1]}".colorize(:light_blue)
            sleep 2
            JobSearch::Scraper.scrape_job_link JobSearch::Category.jobs[input.to_i - 1]
            JobSearch::Job.all[0].category = JobSearch::Category.all[0]
        else
            error_message
            user_job_selection
        end
        explore_the_job
    end

    def self.reset_program
        JobSearch::Job.destroy
        JobSearch::Category.destroy_all
    end
end
