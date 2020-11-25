require 'nokogiri'
require 'open-uri'
require 'pry'
require 'colorize'
require_relative 'version'

class JobSearch::CLI 

    def program_run
        greeting
        create_and_display_categories
        user_category_selection 
        create_and_display_all_job_listings
        user_job_selection 
        explore_the_job 
        view_another_job_or_category?
    end

    def greeting
        puts "Welcome to the Craigslist Job Search!".colorize(:blue)
        puts "Please choose from a category below:".colorize(:blue)
        sleep(2)

        puts "Which category would you like more information on?".colorize(:yellow)
        puts "Choose the corresponding number from the list to get more information.".colorize(:yellow)
        puts "For example, enter '1' for 'accounting-finance' job information.".colorize(:yellow)
        sleep(4)
    end

    def create_and_display_categories
        categories = JobSearch::Scraper.scrape_site #store site data in categories variable
        JobSearch::Category.all.each.with_index(1) {|category, index| puts "#{index}. #{category.category_name}"}
    end   

    def user_category_selection
        input = gets.strip

        if  (1..JobSearch::Category.all.size).include?(input.to_i)
            puts "You've selected the category " + "#{JobSearch::Category.all[input.to_i - 1].category_name}!".colorize(:red)
            
            sleep(2)
            JobSearch::Scraper.scrape_category_for_job_links(JobSearch::Category.all[input.to_i - 1].link) #scrape this
        else
            puts "Sorry, that's not valid input, please try again.".upcase.colorize(:red)
            puts "Choose the corresponding number from the list to get more information.".colorize(:yellow)
            puts "For example, enter '1' for 'accounting-finance' job information.".colorize(:yellow)

            user_category_selection
        end
    end

    def create_and_display_all_job_listings
        puts "Which job would you like more information on?".colorize(:green)
        puts "Available jobs in this category:".colorize(:blue)
        puts "--------------------------------"

        JobSearch::Category.jobs.each.with_index(1) { |j, index| puts "#{index}. #{j.split("/d/").last.split('/').first}" }
    end

    def user_job_selection
        input = gets.strip.downcase

        if (1..JobSearch::Category.jobs.size).include?(input.to_i) 
            puts "Here is the job link if you'd like to view the job page: " + "#{JobSearch::Category.jobs[input.to_i - 1]}".colorize(:light_blue)
            sleep(2)
            JobSearch::Scraper.scrape_job_link(JobSearch::Category.jobs[input.to_i - 1])
            JobSearch::Job.all[0].category = JobSearch::Category.all[0]
        else
            puts "Sorry, that's not valid input. Please try again.".upcase.colorize(:red)
            user_job_selection
        end
    end

    def explore_the_job
        job = JobSearch::Job.all.last
        
        puts "What information would you like to know about the job you selected?".colorize(:yellow)
        puts "Enter 'title' or '1' for job title.".colorize(:yellow)
        puts "Enter 'details' or '2' for job details.".colorize(:yellow)
        puts "Enter 'job type' or '3' for the type of employement (PT/FT, hourly, etc.).".colorize(:yellow)
        puts "Enter 'pay' or '4' to get the job's compensation.".colorize(:yellow)
        puts "Enter 'overall' or '5' if you would like to view all details at once.".colorize(:yellow)
        puts "Enter 'done' if you are finished viewing information about the job.".colorize(:yellow)

        input = gets.strip.downcase
        if input == '1' || input == 'title'
            puts "#{job.title}".colorize(:green)
        elsif input == '2' || input == 'details'
            puts "#{job.body}".colorize(:green)
        elsif input == '3' || input == 'job type'
            puts "#{job.employment_type}".colorize(:green)
        elsif input == '4' || input == 'pay'
            puts "#{job.compensation}".colorize(:green)
        elsif input == '5' || input == 'overall'
            puts "#{job.descriptor}".colorize(:green)
        elsif input == 'done'
            puts "All finished with this job?".colorize(:yellow)
        else 
            puts "Please select one of the inputs mentioned above.".upcase.colorize(:red)
        end
        sleep(2)

        explore_the_job unless input == 'done'
    end

    def view_another_job_or_category?
        puts "Would you like to make another selection?"
        puts "To continue, enter 'yes'."
        puts "Type 'exit' to end the program"

        input = gets.strip.downcase
        
        if input == 'yes'
            JobSearch::CLI.reset_program
            program_run #start program again
        elsif input == 'exit'
            puts "Thank you, and good luck with your job search!".colorize(:green) #end program
        else
            puts "SORRY, BUT ".colorize(:red) + "'#{input}'".colorize(:blue) + " IS NOT A VALID OPTION...TRY AGAIN PLEASE.".colorize(:red)
            view_another_job_or_category?
        end
    end

    def self.reset_program
        JobSearch::Job.destroy
        JobSearch::Category.destroy_all
    end
end