class Movie < ApplicationRecord
  validates :title, presence: true, length: {minimum: 3}

  belongs_to :director
end
