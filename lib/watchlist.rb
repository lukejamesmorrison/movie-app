##
# This class is used to store the user's watchlist.

class Watchlist

    attr_reader :items
    attr_accessor :filename # accessible for testing

    ##
    # Initialize a watchlist and retreive current watchlist from file if it exists.

    def initialize()
        @items = []
        @filename = "watchlist.json"
        get_items_from_file()
    end

    ##
    # Get watchlist items from file if it exists.

    def get_items_from_file()
        if(File.exists?(@filename) && !File.empty?(@filename))
            file = File.read(@filename)
            JSON.parse(file).each do |item|
                movie = Movie.new
                item.each { |key, value| movie.send("#{key}=", value)}
                @items.push(movie)
            end
        end
    end

    ##
    # Add +movie+ to watchlist if doesn't already exist.

    def add(movie)
        # Check if movie is currently in watchlist
        check_count = @items.select do |m| 
            m.title == movie.title && m.year == movie.year
        end

        if(check_count.size == 0)
            @items.push(movie)
            self.save_to_file()
            puts "#{movie.title} has been added to your watchlist.\n".green
        else 
            puts "#{movie.title} is already in your watchlist.\n".red
        end
    end

    ##
    # Remove +movie+ from watchlist if it exists.

    def remove(movie)
        @items.select! do |m| 
            m.title != movie.title && 
            m.year != movie.year
        end

        self.save_to_file()
        puts "#{movie.title} has been removed from your watchlist.\n".green
    end

    ##
    # Save current watchlist to JSON file.

    def save_to_file()
        File.open(@filename,"w") do |f|
            movies_hash = []
            @items.each do |movie|
                movies_hash.push(movie.to_hash)
            end
            f.write(JSON.pretty_generate(movies_hash))
        end
    end

    ##
    # Is the watchlist currently empty?

    def is_empty()
        return @items.empty?
    end

end
