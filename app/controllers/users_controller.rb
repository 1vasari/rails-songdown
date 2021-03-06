class UsersController < ApplicationController
  def home
    @top_songs = current_user.songs.top_songs
    @new_songs = current_user.songs.new_songs
  end

  def settings
  end

  def update
    current_user.update user_params

    if current_user.save
      flash[:notice] = 'Settings saved'
      redirect_to settings_path
    else
      render 'settings'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name)
  end
end
