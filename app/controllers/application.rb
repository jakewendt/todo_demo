class ApplicationController < ActionController::Base

	private #--------------------------------

	def authorize_access
		if not session[:user_id]
			flash[:notice] = "Please log in"
			redirect_to( '/' )
			return false
		else
			@user = User.find(session[:user_id])
		end
	end
end
