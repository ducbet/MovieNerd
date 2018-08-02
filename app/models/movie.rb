class Movie < ApplicationRecord
  include PgSearch

  has_many :screenings
  has_many :rooms, through: :screenings

  validates :title, presence: true, length: {maximum: Settings.title_max_length}

  pg_search_scope :full_text_search,
    against: {
      title: "A",
      director: "B",
      description: "C"
    }
end
