class Application < ApplicationRecord
	belongs_to :user
	belongs_to :post
	validate :cannot_apply_to_own_post

	private

	def cannot_apply_to_own_post
		errors.add(:base, "You can't apply to your own post") if user_id == post.user_id
	end
end
