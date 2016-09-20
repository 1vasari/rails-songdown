
require 'songdown_compiler'

class SongsController < ApplicationController

  before_filter :authenticate_user, :except => []
  before_filter :ensure_user_is_editor, :except => [:show, :index, :print_song]

  def create
    @song = Song.create(song_params)

    if @song.save
      flash[:success] = 'Successfully created new song.'
      redirect_to @song
    else
      render 'new'
    end
  end

  def destroy
    @song = Song.find params[:id]
    @song.destroy

    redirect_to songs_path
  end

  def edit
    @song = Song.find params[:id]
  end

  def index
    if params[:query].instance_of? String
      params[:query].strip!
    end

    @songlist = Song.build_songlist Song.search params[:query]
    @artists = @songlist.keys.sort
  end

  def new
    @song = Song.new
  end

  def print_song
    handle_show
    render :layout => 'print_song'
  end

  def update
    @song = Song.find params[:id]

    if @song.update song_params
      flash[:success] = 'Song updated.'
      redirect_to @song
    else
      render 'edit'
    end
  end

  def show
    handle_show
    IncrementSongViewCounterJob.perform_later @song.id
  end

  private
    def song_params
      params.require(:song).permit(
        :artist,
        :title,
        :content,
        :key,
        :youtube_url
      )
    end

    def handle_show
      @song = Song.find params[:id]
      @compiler = SongdownCompiler.new(
        :input => @song.content,
        :key => @song.key
      )

      if params[:key]
        @compiler.change_key params[:key]
      end

      @song_key = @compiler.key
      @song_html = @compiler.to_html
    end
end
