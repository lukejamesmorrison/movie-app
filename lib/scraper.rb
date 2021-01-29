require 'nokogiri'
require 'open-uri'
require 'movie'

##
# This class is used to scrape IMDB for movie information.

class Scraper
    
    ##
    # Initialize the scraper.

    def initialize()
        @base_url = "https://www.imdb.com"
        # self.get_movie_from_web('home alone')
    end

    ##
    # Get a movie from IMDB based on its +title+.

    def get_movie_from_web(title)
        url = @base_url + "/find?q=#{title}&s=tt&ttype=ft&ref_=fn_ft"

        # Instantiate new Movie
        movie = Movie.new

        # Fetch and parse HTML document
        search_page = Nokogiri::HTML(URI.open(url))

        # Search for list of search results and take first
        item = search_page.css('table.findList tr').first

        # Get initial attributes
        movie.title = item.css('td.result_text > a').text
        movie.image = item.css('td.primary_photo > a > img').attr('src').text
        movie.link = @base_url + item.css('td.result_text > a').attr('href').text

        # Follow url and get additional information from movie page
        movie_page = Nokogiri::HTML(URI.open(movie.link))
        movie.year = movie_page.css('span#titleYear > a').text
        movie.plot = movie_page.css('.summary_text').text.strip
        movie.director = movie_page.css('.plot_summary .credit_summary_item > a')[0].text
        movie.writer = movie_page.css('.plot_summary .credit_summary_item > a')[1].text

        # Cast
        raw_cast = movie_page.css('.plot_summary .credit_summary_item')[2].css('a')
        raw_cast.pop()
        movie.cast = raw_cast.map { |i| i.text }.join(', ')
        
        return movie
    end

end
