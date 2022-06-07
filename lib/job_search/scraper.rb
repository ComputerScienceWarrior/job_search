require 'colorize'
class JobSearch::Scraper

    SITE_TO_SCRAPE = "https://craigslist.org/"

    def self.state_selection
        uri = SITE_TO_SCRAPE
        doc = Nokogiri::HTML(open(uri))

        counter = 0
        doc.search('#rightbar .menu')[0].children[2].children[1].children.each.with_index(1) do |link, index|
            next if index % 2 != 0 || link.children.text == ''
            JobSearch::Location.new(link.children.text, ('https:' + link.children[0].attributes['href'].value))
            counter += 1
            puts "#{counter}. #{link.children.text}"
        end
    end

    

    def self.scrape_site
        uri = SITE_TO_SCRAPE
        doc = Nokogiri::HTML(open(uri))

        #create categories for user to select from
        doc.search('.jobs .cats a').each.with_index(1) do |link, index|
            category = link.children.children.first.text
            link = link.attr('href')
            link[0] = "" #remove
            link = uri + link
            JobSearch::Category.new(category, link)
        end
    end

    def self.scrape_category_for_job_links(category_link)
        doc = Nokogiri::HTML(open(category_link))

        doc.search('.rows .result-info a').each do |row|
            job_link = row.attr('href')
            JobSearch::Category.jobs << job_link unless job_link == '#'
        end
    end

    def self.scrape_job_link(job_selection)
        doc = Nokogiri::HTML(open(job_selection))
        
        unless doc.search('.attrgroup').text.split(": ")[1].nil?
            pay = doc.search('.attrgroup').text.split(": ")[1].split("\n").first
        end

        #format the date before setting it in job object
        date = doc.search('.date.timeago').children[0].text.strip
        year, month, date_time = date.split('-')
        day, time = date_time.split(" ") 
        date = "#{month}-#{day}-#{year} at #{time}."
        
        JobSearch::Job.new(
            doc.search('.postingtitletext #titletextonly').text.strip, #title
            pay, #compensation
            doc.search('.attrgroup').text.strip.split(" ").last, #job type
            doc.search('#postingbody').text.split("\n").join(" ").gsub("                    QR Code Link to This Post                    ", "").strip#body
        )   
        JobSearch::Job.all[0].date = date #date
    end
end