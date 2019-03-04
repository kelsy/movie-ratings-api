require "sinatra"
require 'sinatra/json'
require "sinatra/activerecord"
require 'sinatra/cross_origin'
require './models/movie'
require './services/movie_service'

configure do
  enable :cross_origin
end

class MovieRatingsAPI < Sinatra::Base
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get "/movies" do
    json Movie.all
  end

  get "/movie/:id" do
    movie = MovieService.find_by_id(params[:id])
    halt 404 unless movie
    json movie
  end

  get "/find_movie" do
    result = {}
    title = params[:title]
    if title
      result = MovieService.find_by_title(title)
    end
    json result
  end

  post "/movie" do
    data = JSON.parse(request.body.read)
    movie = Movie.create(data)

    if movie
      json movie
    else
      halt 500
    end
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end
