require 'rubygems'
require 'open-uri'
require 'nokogiri'

def get_trainings(base, page_size = 10, offset = 0)
    url = base + '&size=' + page_size.to_s + '&offset=' + offset.to_s
    puts "Opening #{url}"

    doc = Nokogiri::XML(open(url))
    total = doc.css('meta results').text.to_i

    File.open('trainings.xml', 'w') { |f| f.write('<?xml version="1.0" encoding="UTF-8"?><trainings>') } if offset == 0

    doc.css('training').each do |training|
      File.open('trainings.xml', 'a') {|f| f.write(training.to_s << "\n") }
    end

    File.open('trainings.xml', 'w') { |f| f.write('</trainings') } if offset >= total

    # Find the next link and open it, if it exists
    if(offset < total)
      get_trainings(base, page_size, (offset + page_size))
    end
    puts 'Finished crawling'
end

get_trainings('http://data.springest.nl/trainings.xml?api_key=YOUR_API_KEY')