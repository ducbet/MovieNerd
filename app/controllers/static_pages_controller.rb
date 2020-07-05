class StaticPagesController < ApplicationController
  def home
  	flash.now[:info] = 'Sign up functions has been disabled. Admin email: "b@b.b", password: "asdasd". User email: "a@a.a", password: "asdasd". Mod email: "c@c.c", password: "asdasd"'
    @movies = Movie.page(params[:page])
                   .per Settings.movie.per_page
  end
end
