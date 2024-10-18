class Movie < ApplicationRecord
  validates :title, presence: true, length: {minimum: 3}
  validates :director, presence: true, length: {minimum: 3}
end
