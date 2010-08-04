#	required for the captcha open line
require 'open-uri'

class UsersController < ApplicationController

	before_filter :authorize_access, 
		:except => [:index, :new, :create, :send_login]

	verify :method => :post, 
		:only => [ :new, :destroy, :create, :update ],
		:redirect_to => { :action => :list }

	def index
	end

	def list
		@user_pages, @users = paginate :users, :per_page => 10
	end

	def show
#		@user = User.find(params[:id])
		@user = User.find(session[:user_id])
	end

	def new
		flash.discard
		@user = User.new
	end

	def create
		unless ( captcha_pass?( params[:code], params[:answer] ) )
			flash[:error] = 'Captcha value was incorrect.'
			redirect_to( :back )
			return
		end
		@user = User.new( params[:user] )
		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = 'User was successfully created.'
			redirect_to( :action => 'list' )

			@category = Category.new(
				 :name => "MyFirstCategory",
				 :color => "#0F0",
				 :user_id => @user.id )
			@category.save

			@item = Item.new( 
				:name => "My First Thing To Do", 
				:category_id => @category.id, 
				:priority => "1",
				:done => "0",
				:due_date => "2007-12-31",
				:user_id => @user.id )
			@item.save

		else
			render :action => 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
		unless @user.is_editable_by?( session[:user_id] )
			flash[:warn] = 'You are not authorized to edit this user.'
			redirect_to( :action => 'show', :id => params[:id] )
		end
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:notice] = 'User was successfully updated.'
			redirect_to( :action => 'show', :id => @user )
		else
			render :action => 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		redirect_to( :action => 'list' )
	end

	def captcha_pass?( code, answer )
		#	from http://errtheblog.com/post/585
		code = code.to_i
		answer  = answer.gsub(/\W/, '')
		val = open("http://captchator.com/captcha/check_answer/#{code}/#{answer}").read.to_i.nonzero? rescue false
	end

	def send_login
		@user = User.new(params[:user])
		logged_in_user = @user.try_to_login
		if logged_in_user
			session[:user_id] = logged_in_user.id
			flash.discard
			redirect_to( :controller => 'items' )
		else
			flash[:warn] = "Username/password combination incorrect."
			redirect_to( :back )
		end
	end

	def logout
#		session[:user_id] = nil
		reset_session
		flash[:notice] = "You are now logged out."
		redirect_to('/')
	end
end
