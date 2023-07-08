class RoomsController < ApplicationController
    def index
        @user = session[:user]
        @user_id = session[:user]['id']
        user = User.find(@user_id)
        @rooms = Room.joins(:participants).where(participants: { user_id: @user_id })
        puts "these are the rooms #{@rooms}"
        if @rooms.any?
            redirect_to "/users/#{@rooms.first.id}"
        end

    end

    def show
        @user = session[:user]
        @user_id = session[:user]['id']
        @rooms = Room.joins(:participants).where(participants: { user_id: @user_id })
        @room = Room.find(params[:id])
        if @room
            @messages = @room.messages.order(created_at: :asc)
        end
        render "index"
    end
end