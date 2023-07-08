class PostsController < ApplicationController

	def index
		if !session[:user].present?
			redirect_to login_path
		else
			#Get current user location
			if params[:latitude].present? && params[:longitude].present?
			latitude = params[:latitude]
			longitude = params[:longitude]
			current_user = User.find(session[:user]['id'])
			current_user.update_columns(latitude: latitude, longitude: longitude)
			current_user.save
			end

			#Get posts by other users (exclude applied posts)
			@user = session[:user]
			post_ids_with_applications = Application.where(user_id: session[:user]['id']).pluck(:post_id)
			@posts = Post.joins(:user).where.not(user_id: session[:user]['id']).where.not(id: post_ids_with_applications).where(status: nil).select('posts.*, users.first_name, users.last_name')
		end
	end


	def new
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		post_id = params[:post][:id]
		@user = User.find(session[:user]['id'])
		@post = Post.find(post_id)
		@posts = @user.posts
		if @post.update(post_params)
			message = "Post updated!"
		else
			errors = @post.errors.full_messages
		end
		turbo_stream.update("post-list", partial: "posts/your_shifts", locals: { posts: @posts })
		render turbo_stream: turbo_stream.update("message", partial: "posts/validations", locals: { message: message, errors: errors })
	end

	def destroy
		user = User.find(session[:user]['id'])
		@posts = user.posts
		post_id = params[:id]
		post = Post.find(post_id).destroy
		render turbo_stream: turbo_stream.update("post-list", partial: "posts/your_shifts", locals: { posts: @posts })
	end

	def show
		@post = Post.find(params[:id])
		@current_user = User.find(session[:user]['id'])
		puts "this is post's user id: #{@post.user_id}"
		puts "this is current user's id: #{@current_user.id}"
	end

	def create_post
		@user = User.find(session[:user]['id'])
		@post = Post.new(post_params)
		@post.user = @user

		if @post.save
			redirect_to '/posts'
		else
			flash[:errors] = @post.errors.full_messages
			redirect_to '/posts'
		end
	end

	def applicants
		@user = session[:user]
		user = User.find(session[:user]['id'])
		@posts = user.posts
	end

	def delete_application
		user = User.find(session[:user]['id'])
		user.applications.where(post_id: params[:id]).destroy_all
		post = Post.find(params[:id])
		@current_user_id = session[:user]['id']
		@posts = Post.joins(:applications).where(applications: {user_id: @current_user_id})



		if post.assigned_to_id == session[:user]['id']
			post.update(assigned_to_id: nil, status: nil)
			room = Room.where(post_id: params[:id])
			room.destroy_all
		end


		render turbo_stream: turbo_stream.update("applied-list", partial: "posts/applied_list", locals: { posts: @posts })
	end

	def assign_applicant
		post_id = params[:post_id]
		user_id = params[:user_id]
		@user = User.find(params[:user_id])
		@current_user = User.find(session[:user]['id'])
		post = Post.find(post_id) # replace `post_id` with the actual ID of the post you want to update
		if post.update(assigned_to_id: user_id, status: 1) # replace `user_id` with the actual ID of the user you want to assign, and `1` with the status you want to set
			@room_name = get_name(@user, @current_user)
			@new_room = Room.create(name: @room_name, post_id: post_id)
			Participant.create(user_id: session[:user]['id'], room_id: @new_room.id)
			Participant.create(user_id: user_id, room_id: @new_room.id)
		end

		@posts = @current_user.posts
		render turbo_stream: turbo_stream.update("post-list", partial: "posts/your_shifts", locals: { posts: @posts })
	end

	def nearby
		@user = session[:user]
		user = User.find(session[:user]['id'])
		post_ids_with_applications = Application.where(user_id: session[:user]['id']).pluck(:post_id)
		radius = user.radius
		@posts = Post.near([user.latitude, user.longitude], radius).where.not(id: post_ids_with_applications).where.not(user_id: user.id)
	end

	def cancel_assignee
		user = User.find(session[:user]['id'])
		@posts = user.posts
		post_id = params[:post_id]
		post = Post.find(post_id) # replace `post_id` with the actual ID of the post you want to update
		post.update(assigned_to_id: nil, status: nil) # replace `user_id` with the actual ID of the user you want to assign, and `1` with the status you want to set
		room = Room.where(post_id: post_id)
		room.destroy_all
		render turbo_stream: turbo_stream.update("post-list", partial: "posts/your_shifts", locals: { posts: @posts })
	end

	def apply
		@post = Post.find(params[:id])
		if @post.status != 1
			@user = User.find(session[:user]['id'])
			@user.applications.create(post: @post)
			redirect_back(fallback_location: root_path)
		else
			redirect_to root_path, alert: 'Cannot apply to this post, it has already been assigned or closed.'
		end
	end

	def applied
		@user = session[:user]
		@current_user_id = session[:user]['id']
		@posts = Post.joins(:applications).where(applications: {user_id: @current_user_id})
	end

  	private

	def post_params
		params.require(:post).permit(:title, :hospital, :area, :specialty, :fee, :time_in, :time_out, :notes)
	end

	def get_name(user1, user2)
		users = [user1, user2].sort
		"private_#{users[0].id}_#{users[1].id}"
	end
end 