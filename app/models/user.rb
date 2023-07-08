class User < ApplicationRecord
	has_secure_password
	has_many :posts
	has_many :applications
	has_many :rooms, dependent: :destroy
	has_many :messages, dependent: :destroy
	validates :area, presence: true, length: { minimum: 2 }
	validates :username, presence: true, uniqueness: true, length: { minimum: 5 }
	validates :first_name, presence: true, length: { minimum: 2 }
	validates :last_name, presence: true, length: { minimum: 2 }
	validates :email, presence: true, uniqueness: true
	validates :password, presence: true, confirmation: true
	validates :password_confirmation, presence: true, if: :password_changed?

	def password_changed?
		password_digest_changed? || new_record?
	end
end