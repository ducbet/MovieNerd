class Order < ApplicationRecord
  enum paid: [:paid, :unpaid]

  belongs_to :user
  belongs_to :screening
  has_many :movie_tickets, dependent: :destroy
  has_many :seats, through: :movie_tickets

  validates :user, presence: true
  validates :screening, presence: true
  validates :paid, presence: true

  def delete_unpaid
    destroy if unpaid?
  end
  handle_asynchronously :delete_unpaid, run_at: Proc.new { 5.minutes.from_now }

  def show_seats
    str = []
    seats.each do |seat|
      str.push(" #{I18n.t('seats.row')}#{seat.row}x"\
        "#{I18n.t('seats.number')}#{seat.number} ")
      str.push("||")
    end
    str.pop
    str
  end
end
