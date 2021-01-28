class Movie

    attr_accessor :title, :year, :plot, :link, :image

    def initialize()
    end

    def to_hash
        Hash[*instance_variables.map { |v|
            [
                v.to_s.gsub(/@/, ''), 
                instance_variable_get(v)
            ]
        }.flatten]
    end

end
