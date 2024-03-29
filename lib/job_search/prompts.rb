require 'colorize'

def greeting
    puts "Welcome to the Craigslist Job Search!".colorize(:blue)
    sleep 3
    val = get_states
    which_category_prompt
    val = val.split(" ").last unless val.nil?
end

def which_category_prompt
    puts "Please choose from a category below:".colorize(:blue)
    sleep 2
    puts "Which category would you like more information on?".colorize(:yellow)
    puts "Choose the corresponding number from the list to get more information.".colorize(:yellow)
    puts "For example, enter '1' for 'accounting-finance' job information.".colorize(:yellow)
    sleep 4
end

def job_info_prompt
    puts "What information would you like to know about the job you selected?".colorize(:yellow)
    puts "Enter 'title' or '1' for job title.".colorize(:yellow)
    puts "Enter 'details' or '2' for job details.".colorize(:yellow)
    puts "Enter 'job type' or '3' for the type of employement (PT/FT, hourly, etc.).".colorize(:yellow)
    puts "Enter 'pay' or '4' to get the job's compensation.".colorize(:yellow)
    puts "Enter 'overall' or '5' if you would like to view all details at once.".colorize(:yellow)
    puts "Enter 'done' if you are finished viewing information about the job.".colorize(:yellow)
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

def which_job_info?
    puts "Which job would you like more information on?".colorize(:green)
    sleep 3
    puts "Available jobs in this category:".colorize(:blue)
    sleep 3
    puts "--------------------------------"
end

def explore_the_job
    job = JobSearch::Job.all.last
    job_info_prompt

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
    sleep 2

    explore_the_job unless input == 'done'
end
