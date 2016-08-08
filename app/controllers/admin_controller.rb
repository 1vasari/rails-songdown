class AdminController < ApplicationController

  before_filter :authenticate_user, :except => []
  before_filter :ensure_user_is_admin, :except => []

  def index
    @users = User.all
  end

  def reassign_role
    user = User.find user_params[:id]

    if user
      user.role = user_params[:role]

      if user.save :validate => false
        flash[:success] = 'Successfully updated user role.'
        redirect_to :controller => 'admin', :action => 'index'
      else
        flash[:error] = 'Failed to update user role.'
        redirect_to :controller => 'admin', :action => 'index'
      end
    else
      flash[:error] = 'User not found.'
      redirect_to :controller => 'admin', :action => 'index'
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :role,
        :id
      )
    end
end
