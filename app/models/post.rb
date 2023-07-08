class Post < ApplicationRecord
	belongs_to :user
	belongs_to :assigned_to, class_name: 'User', optional: true
	has_many :applications, dependent: :destroy
	has_one :room, dependent: :destroy

	validates :title, presence: true, length: { minimum: 3 }
	validates :hospital, presence: true, length: { minimum: 3 }
	validates :area, presence: true
	validates :specialty, presence: true, length: { minimum: 3 }
	validates :fee, presence: true, numericality: { greater_than_or_equal_to: 2 }
	validate :time_in_cannot_be_in_the_past
	validate :time_out_cannot_be_before_time_in

	geocoded_by :hospital
	after_validation :geocode

	def time_in_cannot_be_in_the_past
		if time_in.present? && time_in < Time.now
			errors.add(:time_in, "can't be in the past")
		end
	end

	def time_out_cannot_be_before_time_in
		if time_out.present? && time_out < time_in
			errors.add(:time_out, "can't be before time in")
		end
	end
end
  