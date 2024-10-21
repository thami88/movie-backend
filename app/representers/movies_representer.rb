class MoviesRepresenter
  def initialize(movies)
    @movies = movies
  end

  def as_json
    movies.map do |movie|
      {
        id: movie.id,
        title: movie.title,
        director_name: director_name(movie),
        director_age: movie.director.age
      }
    end
  end

  private

  attr_reader :movies

  def director_name(movie)
    "#{movie.director.first_name} #{movie.director.last_name}"
  end

end
