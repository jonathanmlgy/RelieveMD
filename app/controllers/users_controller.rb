class UsersController < ApplicationController
	layout "main", only: [:login, :new]
	def index

	end

	def login
	end

	def validate_login
		@user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user] = @user
			redirect_to '/'
		else
			flash[:errors] = ["Invalid email/password combination"]
			redirect_to '/login'
		end
	end

	def new
	end

	def show_profile
		@user = User.find(session[:user]['id'])
	end

	def edit_profile
		@user = User.find(session[:user]['id'])
		render turbo_stream: turbo_stream.update("profile", partial: "users/edit_profile", locals: { user: @user })
	end

	def create
		@user = User.create(user_params)
		if @user.persisted?
			redirect_to '/login'
		else
			flash[:errors] = @user.errors.full_messages
			redirect_to signup_path
		end
	end

	def update
		@user = User.find(session[:user]['id'])
		user = User.find(session[:user]['id'])
		if user.authenticate(params[:user][:password])
			user.update(user_params)
			if user.errors.any?
			@errors = user.errors.full_messages
			render turbo_stream: turbo_stream.update("profile", partial: "users/user_profile", locals: { user: @user, errors: @errors })
			else
			@user = User.find(session[:user]['id'])
			render turbo_stream: turbo_stream.update("profile", partial: "users/user_profile", locals: { user: @user, errors: [] })  
			end
		else
			@errors = ["Wrong password!"]
			render turbo_stream: turbo_stream.update("profile", partial: "users/user_profile", locals: { user: @user, errors: @errors })
		end
	end

	def update_password
		@user = User.find(session[:user]['id'])
		if @user.authenticate(params[:user][:password])
			if @user.update(password: params[:user][:new_password], password_confirmation: params[:user][:password_confirmation])
			message = "Password updated successfully."
			else
			message = "Password confirmation does not match"
			end
		else
			message = "Old password is incorrect."
		end

		render turbo_stream: turbo_stream.update("profile", partial: "users/change_password", locals: { message: message })
	end

	def change_password
		@user = User.find(session[:user]['id'])
		render turbo_stream: turbo_stream.update("profile", partial: "users/change_password", locals: { message: nil})
	end


	def logout
		reset_session
		redirect_to '/login'
	end
  
  	private

	def user_params
		params.require(:user).permit(:username, :first_name, :last_name, :email, :area, :password, :password_confirmation, :radius)
	end  
  
end
