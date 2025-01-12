class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = ''
    if session[:sort]
      @sort = session[:sort]
    end
    if params[:sort]
      @sort = params[:sort]
    end
    session[:sort] = @sort
    
    @all_ratings = Movie.all_ratings
    
    @ratings = @all_ratings
    if params[:ratings]
      @ratings = params[:ratings].keys
    elsif session[:ratings]
      redirect_to movies_path(
        sort: session[:sort],
        ratings: Hash[session[:ratings].map {|r| [r, 1]}])
      return
    end
    session[:ratings] = @ratings

    @movies = Movie.order(@sort).where(rating: @ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
