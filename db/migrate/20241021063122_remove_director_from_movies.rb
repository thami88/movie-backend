class RemoveDirectorFromMovies < ActiveRecord::Migration[6.1]
  def change
    remove_column :movies, :director, :string
  end
end
