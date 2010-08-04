class CategoriesController < ApplicationController

	before_filter :authorize_access

	def index
		list
		render :action => 'list'
	end

	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
	verify :method => :post, 
		:only => [ :destroy, :create, :update ],
		:redirect_to => { :action => :list }

	def list
		@category_pages, @categories = paginate :categories, :per_page => 10,
			:conditions => [ 'user_id = ?', session[:user_id]],
			:order => 'name'
	end

#	def show
#		@category = Category.find(params[:id])
#	end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(params[:category])
		@category.user_id = session[:user_id]
		if @category.save
			flash[:notice] = 'Category was successfully created.'
			redirect_to :action => 'list'
		else
			render :action => 'new'
		end
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update_attributes(params[:category])
			flash[:notice] = 'Category was successfully updated.'
			redirect_to :action => 'list', :id => @category
		else
			render :action => 'edit'
		end
	end

	def destroy
		Category.find(params[:id]).destroy
		flash[:notice] = 'Category was successfully deleted.'
		redirect_to :action => 'list'
	end
end
