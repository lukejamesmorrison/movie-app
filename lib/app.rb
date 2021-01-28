require 'json'
require "version"
require "scraper"
require "colorize"
require "watchlist"

class App

  def initialize()
    @scraper = Scraper.new
    @watchlist = Watchlist.new
  end

  def run()
    # Display greeting
    self.display_greeting()
    self.main_menu()
  end

  def display_greeting()
    puts "####################################################################################"
    puts "####      ####      ####      ####      ####      ####      ####      ####      ####"
    puts "####      ####      ####      ####      ####      ####      ####      ####      ####"
    puts "####################################################################################"
    puts "          ####                                                        ####"
    puts "          ####                                                        ####"
    puts "          ####  MOVIE APP                                             ####"
    puts "          ####                                                        ####"
    puts "          ####  Hello! This app will allow you to search for movies   ####"
    puts "          ####  and save them to a watchlist to view later.           ####"
    puts "          ####                                                        ####"
    puts "          ####                                                        ####"
    puts "####################################################################################"
    puts "####      ####      ####      ####      ####      ####      ####      ####      ####"
    puts "####      ####      ####      ####      ####      ####      ####      ####      ####"
    puts "####################################################################################\n\n"
  end

  def display_header(text)
    width = 35  # The total width of the block
    padding = 2 # The horizontal padding
    space = width - 2 # The inner (empty) space width
    outer = ("#" * width) + "\n" # The upper or lower border row
    spacer = "#" + (" " * space) + "#\n" # An 'empty' row
    text = "#" + (" " * padding) + text.upcase + (" " * (width-text.size-(padding*2))) + "#\n" # The text row

    puts (outer + spacer + text + spacer + outer + "\n")
  end

  def main_menu()
    # Display initial menu
    self.display_header('main menu')
    puts "What would you like to do?\n".blue
    puts "1.  Search for a movie"
    puts "2.  View wishlist"
    puts "3.  Exit"
    puts ""

    # Get user selection
    print "Enter a number [1-3]: ".blue
    selection = gets.chomp.to_i
    puts ""

    # Run selection
    case selection
      when 1
        self.search_for_movie()
      when 2
        self.display_watchlist()
        self.watchlist_menu()
      when 3
        puts "Goodbye :)\n\n".green
        exit
      else
        puts "Incorrect input. Try again.\n\n".red
        self.main_menu()
      end

  end

  def search_for_movie()
    # Get user input
    print "What is the name of the movie you wish to find? ".blue
    title = gets.chomp.to_s
    movie = @scraper.get_movie_from_web(title)

    # display movie info
    self.display_movie_info(movie)
    self.movie_search_menu(movie)
  end

  def display_movie_info(movie)
    self.display_header('movie information')
    puts "Title:      #{movie.title}".green
    puts "Year:       #{movie.year}".green
    puts ""
    puts "Synopsis:   #{movie.plot}\n\n".green
  end

  def movie_search_menu(movie)
    # Display movie search menu
    puts "What would you like to do?\n".blue
    puts "1.  Save movie to wishlist"
    puts "2.  Search again"
    puts "3.  Return to main menu"
    puts ""

    # Get user selection
    print "Enter a number [1-3]: ".blue
    selection = gets.chomp.to_i
    puts ""

    # Run selection
    case selection
      when 1
        @watchlist.add(movie)
        self.main_menu()
      when 2
        self.search_for_movie()
      when 3
        main_menu()
      else
        puts "Incorrect input. Try again.\n".red
        self.display_movie_info(movie)
        self.movie_search_menu(movie)
    end
  end

  def display_watchlist()
    self.display_header('watchlist')
    @watchlist.items.each_with_index do |movie, index|
      puts "#{index+1}.   #{movie.title} (#{movie.year})"
    end
    puts ""
  end

  def watchlist_menu()
    # Display watchlist menu
    puts "What would you like to do?\n".blue
    puts "1.  View details for movie"
    puts "2.  Return to main menu"
    puts ""

    # Get user selection
    print "Enter a number [1-2]: ".blue
    selection = gets.chomp.to_i
    puts ""

    # Run selection
    case selection
      when 1
        self.display_watchlist()
        print "Which movie would you like to view? [#]: ".blue
        selection = gets.chomp.to_i
        puts ""
        movie = @watchlist.items[selection-1]
        self.display_movie(movie)
        self.movie_menu(movie)
      when 2
        self.main_menu()
      else
        puts "Incorrect input. Try again.\n".red
        self.watchlist_menu()
    end
  end

  def display_movie(movie)
    self.display_movie_info(movie)
    self.movie_menu(movie)
  end

  def movie_menu(movie)
    # Display movie menu
    puts "What would you like to do?\n".blue
    puts "1.  Remove from watchlist"
    puts "2.  Return to watchlist"
    puts "3.  Return to main menu"
    puts ""

    # Get user selection
    print "Enter a number [1-3]: ".blue
    selection = gets.chomp.to_i
    puts ""

    # Run selection
    case selection
      when 1
        @watchlist.remove(movie)
        self.display_watchlist()
        self.watchlist_menu()
      when 2
        self.display_watchlist()
        self.watchlist_menu()
      when 3
        self.main_menu()
      else
        puts "Incorrect input. Try again.\n".red
        self.movie_menu(movie)
    end
  end


  class Error < StandardError; end
  # Your code goes here...
end
