class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings

    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      params[:sort] = session[:sort]
    end

    if params['ratings']
      @ratings_to_show = params['ratings'].keys
      session[:ratings] = @ratings_to_show
    elsif params[:ratings]
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show
    elsif session[:ratings]
      @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = []
    end

    if params[:sort] == 'title'
      @movies = Movie.with_ratings(@ratings_to_show).order(:title)
    elsif params[:sort] == 'date'
      @movies = Movie.with_ratings(@ratings_to_show).order(:release_date)
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end

    
    # if !params[:sort]
    #   if params['ratings']
    #     @ratings_to_show = params['ratings'].keys
    #     session[:ratings] = @ratings_to_show
    #   elsif session[:ratings]
    #     @ratings_to_show = session[:ratings]
    #   else
    #     @ratings_to_show = []
    #   end
    #   @movies = Movie.with_ratings(@ratings_to_show)
    # else
    #   @ratings_to_show = params[:ratings].keys
    #   session[:ratings] = @ratings_to_show
    #   if params[:sort] == 'title'
    #       @movies = Movie.with_ratings(@ratings_to_show).order(:title)
    #   end

    #   if params[:sort] == 'date'
    #       @movies = Movie.with_ratings(@ratings_to_show).order(:release_date)
    #   end
    # end



    # if !params[:sort]
    #   if params['ratings']
    #     @ratings_to_show = params['ratings'].keys
    #   else
    #     @ratings_to_show = []
    #   end
    #   @movies = Movie.with_ratings(@ratings_to_show)
    # else
    #   if params[:ratings]
    #     @ratings_to_show = params[:ratings].keys
    #   else
    #     @ratings_to_show = []
    #   end
    #   if params[:sort] == 'title'
    #     @movies = Movie.with_ratings(@ratings_to_show).order(:title)
    #   elsif params[:sort] == 'date'
    #     @movies = Movie.with_ratings(@ratings_to_show).order(:release_date)
    #   end
    # end

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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end