require_relative "../app"
require_relative "test_helper"
require "rack/test"

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    MovieRatingsAPI
  end

  def setup
    filepath = File.dirname(__FILE__) + "/data/sample_response.json"
    sample_response_file = File.read(filepath)
    sample_response_data = JSON.parse(sample_response_file)

    # We don't want to call out to the actual API during testing
    MovieService.stubs(:search_ombd_api).returns(sample_response_data)
    cleanup_test_movie
  end

  def teardown
    cleanup_test_movie
  end

  def test_movies
    get "/movies"
    assert last_response.ok?
    puts last_response.body.inspect
  end

  def test_get_movie_by_id
    movie = Movie.create({
      "title" => "Spaceballs",
      "review" => "This movie is great!",
      "rating" => 5
    })

    get "/movie/#{movie.id}"

    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal "Spaceballs", response["title"]
    refute_nil response["plot"]
    assert_equal "1987", response["year"]
    assert_equal movie.id, response["id"]
    assert_equal "This movie is great!", response["review"]
    assert_equal 5, response["rating"]
  end

  def test_find_new_movie
    get "/find_movie?title='Spaceballs'"
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal "Spaceballs", response["title"]
    refute_nil response["plot"]
    assert_equal "1987", response["year"]
    refute response["id"]
  end

  def test_find_existing_movie
    movie = Movie.create({
      "title" => "Spaceballs",
      "review" => "This movie is great!",
      "rating" => 5
    })

    get "/find_movie?title='Spaceballs'"
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal "Spaceballs", response["title"]
    refute_nil response["plot"]
    assert_equal "1987", response["year"]
    assert_equal movie.id, response["id"]
    assert_equal "This movie is great!", response["review"]
    assert_equal 5, response["rating"]
  end

  def test_creating_movie
    movie_data = {
      "title" => "Spaceballs",
      "rating" => 4,
      "review" => "This movie is pretty good."
    }.to_json

    post "/movie", movie_data, {"CONTENT_TYPE" => "application/json"}
    assert last_response.ok?
    response = JSON.parse(last_response.body)

    refute_nil response["id"]
    assert_equal "Spaceballs", response["title"]
    assert_equal "This movie is pretty good.", response["review"]
  end

  # Ideally it would be nice to set up rollbacks and use 
  # something more sophisticated for testing
  def cleanup_test_movie
    movie = Movie.where(title: "Spaceballs").first
    movie.delete if movie
  end
end
