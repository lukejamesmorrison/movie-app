require 'json'
require "version"
require "scraper"
require "colorize"
require "watchlist"

##
# This class is the entire application wrapper.  It uses a Scraper to get information 
# from IMDB and has a Watchlist where the user can save movies for later.

class App

  ##
  # Initialize the app with a Scraper and a Watchlist.

  def initialize()
    @scraper = Scraper.new
    @watchlist = Watchlist.new
  end

  ##
  # Run application.

  def run()
    self.display_greeting()
    self.main_menu()
  end

  ##
  # Display initial greeting.

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

  ##
  # Display a header block with +text+.

  def display_header(text)
    width = 84  # The total width of the block
    padding = 2 # The horizontal padding
    space = width - 2 # The inner (empty) space width
    outer = ("#" * width) + "\n" # The upper or lower border row
    spacer = "#" + (" " * space) + "#\n" # An 'empty' row
    text = "#" + (" " * padding) + text.upcase + (" " * (width-text.size-(padding*2))) + "#\n" # The text row

    puts (outer + spacer + text + spacer + outer + "\n")
  end

  ##
  # Show main menu.

  def main_menu()
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

  ##
  # Search for a movie by title based on user input.

  def search_for_movie()
    # Get user input
    print "What is the name of the movie you wish to find? ".blue
    title = gets.chomp.to_s
    puts ""
    movie = @scraper.get_movie_from_web(title)

    # display movie info
    self.display_movie_info(movie)
    self.movie_search_menu(movie)
  end

  ##
  # Display information for a given +movie+.

  def display_movie_info(movie)
    self.display_header('movie information')
    puts "Title:      #{movie.title}"
    puts "Year:       #{movie.year}\n"
    puts "Synopsis:   #{movie.plot}\n"

    puts "Director:   #{movie.director}\n"
    puts "Writer:     #{movie.writer}\n"
    puts "Cast:       #{movie.cast}\n"
    puts "\n"
  end

  ##
  # Show the movie search menu based on a given +movie+.

  def movie_search_menu(movie)
    # Display movie search menu
    puts "What would you like to do?\n".blue
    puts "1.  Save movie to Wishlist"
    puts "2.  Search again"
    puts "3.  Return to Main Menu"
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

  ##
  # Display current watchlist.

  def display_watchlist()
    self.display_header('watchlist')
    @watchlist.items.each_with_index do |movie, index|
      puts "#{index+1}.   #{movie.title} (#{movie.year})"
    end
    puts ""
  end

  ##
  # Display watchlist menu.

  def watchlist_menu()

    # Redirect to menu if watchlist is empty
    if(@watchlist.is_empty())
      puts "Your watchlist is currently empty.".red
      self.main_menu()
    end

    # Display watchlist menu
    puts "What would you like to do?\n".blue
    puts "1.  View details for Movie"
    puts "2.  Return to Main Menu"
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

  ##
  # Display information for a given +movie+.

  def display_movie(movie)
    self.display_movie_info(movie)
    self.movie_menu(movie)
  end

  ##
  # Display the movie menu for a given +movie+.

  def movie_menu(movie)
    options = [
      'Remove movie from Watchlist',
      'Return to Watchlist',
      'Return to Main Menu'
    ]
    # Display movie menu
    puts "What would you like to do?\n".blue
    options.each_with_index { |option, index| puts "#{index+1}.  #{option}" }
    puts ""

    # Get user selection
    print "Enter an option [1-#{options.size}]: ".blue
    selection = gets.chomp.to_i
    puts ""

    # Run selection
    case selection
      when 1
        @watchlist.remove(movie)
        if(@watchlist.is_empty())
          self.main_menu()
        else
          self.display_watchlist()
          self.watchlist_menu()
        end
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
