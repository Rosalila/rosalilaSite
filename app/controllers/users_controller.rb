class UsersController < ApplicationController
	def index
		@users = User.all
	end
  
	def show
		@user = User.find_by_username(params[:username])
		if @user
			render "show"
		end
	end

	def edit
		@user = User.find_by_username(params[:username])
		if @user
			render "edit"
		end
	end

	def new
		@user = User.new
  end

	def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
	end

	def update
		@user = User.find(params[:id])
		if @user
			@user.username = params[:username]
			@user.email = params[:email]
			@user.bio = params[:bio]
			if @user.save
				redirect_to show_user_url(:username => @user.username), :notice => "Profile Updated"
			else
				render "edit"
			end
		else
			render "edit"
		end
	end
end
