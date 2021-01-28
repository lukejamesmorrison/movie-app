require "version"
require "scraper"

class App

  def initialize()
    @scraper = Scraper.new
    @watchlist = []
  end

  def run()
    # Get watchlist
    # print @watchlist

    # Display greeting
    

    self.search_for_movie('home alone')

  end

  def display_greeting()
    puts "Hello! This app will allow you to search for movies and save them to a watchlist to view later."
  end

  def search_for_movie(title)
    movie = @scraper.get_movie_from_web(title)
  end







  class Error < StandardError; end
  # Your code goes here...
end
