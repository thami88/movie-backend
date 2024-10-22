class MovieRepresenter
  def initialize(movie)
    @movie = movie
  end

  def as_json
      {
        id: movie.id,
        title: movie.title,
        director_name: director_name(movie),
        director_age: movie.director.age
      }
  end

  private

  attr_reader :movie

  def director_name(movie)
    "#{movie.director.first_name} #{movie.director.last_name}"
  end

end
