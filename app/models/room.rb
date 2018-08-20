class Room < ApplicationRecord
  has_many :seats, dependent: :destroy
  has_many :screenings
  has_many :movies, through: :screenings

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  before_save :name_downcase

  def full_a_map
    set_chair row_num, max_seat_per_row
  end

  def set_map new_map
    old_map_element = {}
    new_map_element = {}

    seats.map(&:name).each do |seat_name|
      old_map_element[seat_name.to_s] = "a"
    end

    new_map.each_with_index do |row, row_index|
      row.split("").each_with_index do |status, pos_index|
        new_map_element["#{row_index + 1}_#{pos_index + 1}"] = status
      end
    end

    deleted_seats = old_map_element.keys - new_map_element.keys
    remove_deleted_seats deleted_seats

    new_map_element.each do |seat_name, status|
      seat_toggle seat_name, status
    end
    update_attributes seat_no: seats.count
  end

  def row_num
    seats.map(&:row).uniq.max
  end

  def max_seat_per_row
    seats.map(&:number).uniq.max
  end

  def find_deleted_seats
    seat_exist = seats.map(&:name)
    no_seat = []
    1.upto row_num do |row|
      1.upto max_seat_per_row do |num|
        no_seat << "#{row}_#{num}" unless seat_exist.include? "#{row}_#{num}"
      end
    end
    no_seat
  end

  private

  def set_chair row_num, max_seat_per_row
    map = Array.new(row_num){"_" * max_seat_per_row}
    seats.each do |seat|
      map[seat.row - 1][seat.number - 1] = "a"
    end
    map
  end

  def name_downcase
    self.name = name.downcase
  end

  def remove_deleted_seats deleted_seats
    deleted_seats.each do |seat_name|
      row, num = seat_name.split "_"
      seats.where(row: row, number: num).destroy_all
    end
  end

  def seat_toggle seat_name, status
    row, num = seat_name.split "_"
    seat = seats.find_by row: row, number: num
    if status == "a" && seat.nil?
      seats.create row: row, number: num
    elsif status == "_" && seat
      seat.destroy
    end
  end
end
