require 'rubygems'
require 'nokogiri'
require 'open-uri'

BASE_URL = ARGV[0]
@links = Array.new
@scripts = Array.new

def crawl(url)
        page = Nokogiri::HTML(open(url))
        page.css("a").each do |link|
        link = link['href'].to_s
        # puts link[0,BASE_URL.length]
        if !@links.include?(link) && link[0,BASE_URL.length] == BASE_URL
                if link[0,10] != "javascript" && link[0,1] != '/'
                        puts link
                        @links.push(link)
                        crawl(link)
                elsif (link[0,1] == '/')
                        current_page = "#{BASE_URL}#{link}"
                        if !@links.include?(current_page)
                                puts current_page
                                @links.push(current_page)
                                crawl(current_page)
                        end
                end
        end
        end

        # puts "\nFinding all javascript files"
        #find all javascript files
        page.css('script').each do |script|
                src = script['src'].to_s
                if @scripts.include?(src) && link[0,BASE_URL.length] == BASE_URL
                        if script[0,1] == '/'
                                src = "#{BASE_URL}#{script}"
                        end
                puts src
                @scripts.push(src)
                end
        end
end

crawl(BASE_URL)

puts "\nFound #{@links.count} links"
puts "Found #{@scripts.count} scripts"
