class Watchlist

    attr_reader :items

    def initialize()
        @items = []
        # Get items from file and convert to movies
        get_items_from_file()
    end

    def get_items_from_file()
        file_name = "watchlist.json"
        if(!File.empty?(file_name))
            file = File.read(file_name)
            JSON.parse(file).each do |item|
                movie = Movie.new
                item.each { |key, value| movie.send("#{key}=", value)}
                @items.push(movie)
            end
        end
    end

    # Add movie to watchlist
    def add(movie)

        # Check if movie is currently in watchlist
        check_count = @items.select do |m| 
            m.title == movie.title && m.year == movie.year
        end

        if(check_count.size == 0)
            @items.push(movie)
            # Save new watchlist to file
            self.save_to_file()
            puts "#{movie.title} has been added to your watchlist.\n".green
        else 
            puts "#{movie.title} is already in your watchlist.\n".red
        end
    end

    # Remove movie from watchlist
    def remove(movie)
        @items.select! do |m| 
            m.title != movie.title && m.year != movie.year
        end

        self.save_to_file()
        puts "#{movie.title} has been removed from your watchlist.\n".green
    end

    def save_to_file()
        File.open("watchlist.json","w") do |f|
            movies_hash = []
            @items.each do |movie|
                movies_hash.push(movie.to_hash)
            end
            f.write(JSON.pretty_generate(movies_hash))
        end
    end

end
