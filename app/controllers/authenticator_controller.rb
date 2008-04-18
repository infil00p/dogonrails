class AuthenticatorController < ApplicationController

	before_filter :requires_admin

	def index
		list
		render :action => 'list'
	end

	def list
		@auths = Authenticator.find(:all)
	end

	def new
		@auth = Authenticator.new
	end

	def create
		@auth = Authenticator.create(params[:auth])
	end

  def edit
    @auth = Authenticator.find(params[:id])
  end

	def update
		@auth = Authenticator.find(params[:id])
		@auth.update_attributes(params[:auth])
		@auth.save!
	end

	def destroy
		@auth = Authenticator.find(params[:id])
		@auth.destroy!
	end

end
