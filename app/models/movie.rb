class Movie < ActiveRecord::Base

    def self.all_ratings
        return ['G','PG','PG-13','R']
    end

    def self.with_ratings(ratings_list)
        if ratings_list == []
            return Movie.all
        else
            return Movie.where(rating: ratings_list)
        end
    end
end
