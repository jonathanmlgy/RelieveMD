class MessagesController < ApplicationController
 
	def create
		@user_id = session[:user]['id']
		@message = Message.create(user_id: @user_id, **message_params)
	end


	private

	def message_params
		params.require(:message).permit(:room_id, :content)
	end

end
