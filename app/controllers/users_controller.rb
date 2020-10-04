class UsersController < ApplicationController
  require 'rspotify'

  before_action :spotify_auth #runs the spotify_auth function at the beginning of every user controller function
  skip_before_action(:spotify_auth, { :only => [:spotify_callback] }) #except for spotify_callback


  def spotify_auth
    #if user is not stored in session, get spotify authentication
    #otherwise sets user in @user instance variable
    if !session.key?(:user_hash)
      redirect_to('/auth/spotify')
    else
      user_hash = session[:user_hash]
      @user = RSpotify::User.new(user_hash)
    end
  end

  def spotify_callback
    user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:user_hash] = user.to_hash
    redirect_to("/user_page")
  end

  def user_page
    render({:template => "users/user_page.html.erb"})
  end

  def top_songs_page
    @top_tracks = @user.top_tracks(limit: 50, offset: 0, time_range: 'long_term')
    render({:template => "users/top_songs.html.erb"})
  end

  def top_artists_page
    @top_artists = @user.top_artists(limit: 50, offset:0,time_range: 'long_term')
    render({:template => "users/top_artists.html.erb"})
  end

  def playlists_page
    @playlists = @user.playlists(limit:20, offset:0)
    render({:template => "users/playlists.html.erb"})

  end




end
