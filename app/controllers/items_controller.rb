class ItemsController < ApplicationController

	before_filter :authorize_access

	def index
		list
		render :action => 'list'
	end

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, 
		:only => [ :destroy, :create, :update ],
		:redirect_to => { :action => :list }

	def export
		list
		render :layout => false
	end

	def list
		@conditions = [ 'user_id = ?', session[:user_id] ]
		if params['category']
			@conditions[0] += ' AND category_id = ?'
			@conditions << params['category']
			@category = params['category']
		end
		@items = Item.find(:all,
			:conditions => @conditions)
#		in_place_edit_for :item, :name
	end

	def new
		@categories = Category.find( :all, 
			:conditions => [ 'user_id = ?', session[:user_id]],
			:order => 'name')
		if @categories.length == 0
			flash[:notice] = "Please create at least one category before creating items."
			redirect_to :controller => 'categories', :action => 'new'
		end
		@item = Item.new
	end

	def create
		@item = Item.new(params[:item])
		@item.user_id = session[:user_id]
		if @item.save
			flash[:notice] = 'Item was successfully created.'
			redirect_to :action => 'list'
		else
			render :action => 'new'
		end
	end

	def edit
		@categories = Category.find( :all,
			:conditions => [ 'user_id = ?', session[:user_id]],
			:order => 'name')
		@item = Item.find(params[:id])
	end

	def update
		@item = Item.find(params[:id])
		if @item.update_attributes(params[:item])
			flash[:notice] = 'Item was successfully updated.'
			redirect_to :action => 'list', :id => @item
		else
			render :action => 'edit'
		end
	end

#
#	The following have been "ajaxified"
#

	def destroy
		Item.find(params[:id]).destroy
	end

	def toggle_done
		item = Item.find(params[:id])
		current = ( item.done ) ? "1" : "0"
		@done = ( params[:done].to_s == "1" ) ? "1" : "0"
		if current != @done
			item.update_attribute(:done,@done)
		end
	end

end
