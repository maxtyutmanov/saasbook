class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    movie_filters = {}
    
    @selected_ratings = params[:ratings] || {}
    #filter movies by rating only if refresh button was pressed
    movie_filters[:rating] = @selected_ratings.keys if params[:commit] == 'Refresh'
    
    if (params[:sort_by] == "title")
      @movies = Movie.find(:all, { :order => "title" }, :conditions => movie_filters )
      @title_style = :hilite
    elsif (params[:sort_by] == "release_date")
      @movies = Movie.find(:all, { :order => "release_date" }, :conditions => movie_filters )
      @release_date_style = :hilite
    else
      @movies = Movie.find(:all, :conditions => movie_filters )
    end
    
    @all_ratings = Movie.all_ratings
    
    @ratings_qs_hash = {:commit => params[:commit]}
    @selected_ratings.keys.each { |r| @ratings_qs_hash["ratings[#{r}]"] = 1 }
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
