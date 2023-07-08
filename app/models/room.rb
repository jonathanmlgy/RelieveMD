class Room < ApplicationRecord
	belongs_to :post
	has_many :participants, dependent: :destroy
	has_many :messages, dependent: :destroy
	after_create_commit { broadcast_append_to "rooms" }


	def other_participant(current_user_id)
		other = participants.joins(:user).where.not(users: current_user_id).select('participants.*, users.first_name, users.last_name')
	if other.first
		"#{other.first.user.first_name} #{other.first.user.last_name}"
	end
	end

	def other_id(current_user_id)
		other = participants.where.not(users: current_user_id).first.user_id
	end
end
