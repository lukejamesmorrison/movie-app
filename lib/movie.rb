##
# This class represents a movie.

class Movie

    attr_accessor :title, :year, :plot, :link, :image, :director, :writer, :cast

    ##
    # Convert instance to a hashmap.  This is useful when exporting to JSON.

    def to_hash
        Hash[*instance_variables.map { |v|
            [
                v.to_s.gsub(/@/, ''), 
                instance_variable_get(v)
            ]
        }.flatten]
    end

end
