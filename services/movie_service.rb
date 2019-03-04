require 'net/http'
require 'uri'

class MovieService
  OMDB_API_KEY = ENV["OMDB_API_KEY"]

  def self.find_by_id(id)
    movie = Movie.find_by_id(id)
    return nil unless movie

    result = get_omdb_data(movie.title)
    get_movie_data_hash(result, movie)
  end

  def self.find_by_title(title)
    return {} unless title
    result = get_omdb_data(title)

    movie = Movie.where(title: result["title"]).first
    get_movie_data_hash(result, movie)
  end

  def self.get_movie_data_hash(result = {}, movie = nil)
    if movie
      result["review"] = movie.review
      result["rating"] = movie.rating
      result["id"] = movie.id

      # If the OMDb API is down, we still want to show the
      # user the title of the movie they saved the rating/review for
      result["title"] = movie.title unless result["title"]
    end

    result
  end

  def self.get_omdb_data(title)
    ombd_response = search_ombd_api(title)

    # Leaving in for logging purposes, ideally
    # we would want to handle logs a bit better...
    puts "OMDB RESPONSE: #{ombd_response.inspect}"

    parse_omdb_response(ombd_response)
  end

  # For a larger API or a production system,
  # we would probably want to pull this out into its own service class
  def self.search_ombd_api(title)
    url = URI.parse("http://www.omdbapi.com/?apikey=#{OMDB_API_KEY}&t=#{title}")
    request = Net::HTTP::Get.new(url.request_uri)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.parse_omdb_response(response)
    poster = response["Poster"]
    poster = nil if poster == "N/A"
    return {
      "title" => response["Title"],
      "year" => response["Year"],
      "rated" => response["Rated"],
      "plot" => response["Plot"],
      "poster" => poster,
      "imdbID" => response["imdbID"]
    }
  end
end
