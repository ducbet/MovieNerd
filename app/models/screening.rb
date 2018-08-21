class Screening < ApplicationRecord
  belongs_to :movie
  belongs_to :room
  has_many :orders
  has_many :users, through: :orders

  validates :room, presence: true
  validates :movie, presence: true
  validates :screening_start, presence: true
  validate :show_time
  validate :screening_time_cannot_be_in_the_past
  scope :not_show_yet, (lambda do
    where("screening_start >= :date", date: Date.today)
    .order screening_start: :asc
  end)
  scope :available_date, (lambda do
    pluck(Arel.sql("date(screening_start)")).uniq
  end)
  scope :by_date, (lambda do |date|
    where("screening_start >= ? AND "\
     "screening_start < ?", date, date.tomorrow).order screening_start: :asc
  end)

  def sold_seats
    sold = []
    orders.each do |order|
      order.seats.each do |seat|
        sold << seat.name
      end
    end
    sold
  end

  def available_seats
    available = 0
    orders.each do |order|
      available += order.seats.count
    end
    room.seat_no - available
  end

  private

  def show_time
    return unless screening_start.presence
    return if compare
    errors.add :screening_start,
      I18n.t("activerecord.errors.models.screening.attributes"\
        ".screening_start.invalid")
  end

  def compare
    room.screenings.each do |screening|
      next unless screening.screening_start <= screening_start &&
                  screening_start <= screening.screening_start +
                                     screening.movie.duration.minutes +
                                     Settings.admin.break_time.minutes
      return false
    end
    true
  end

  def screening_time_cannot_be_in_the_past
    return unless screening_start.present? && screening_start < Time.now
    errors.add :screening_start,
      I18n.t("activerecord.errors.models.screening.attributes"\
        ".screening_start.invalid")
  end
end
