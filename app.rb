require "sinatra"
require 'sinatra/json'
require "sinatra/activerecord"
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

class MovieRatingsAPI < Sinatra::Base
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get "/movies" do
    movie = {"id" => 1, "title" => "Movie Title"}
    json [movie]
  end

  get "/movie/:id" do
    movie = {"id" => params[:id], "title" => "Movie #{params[:id]} Title"}
    json movie
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end
