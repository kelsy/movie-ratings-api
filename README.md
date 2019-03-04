# Movie Ratings UI
This is an example of a Vue.js UI with a Sinatra backend and is still a work in progress. Major features are currently missing. See the TO DO section for more information.

The application is live at: https://movie-ratings-ui.herokuapp.com

The Vue.js UI code can be viewed at https://github.com/kelsy/movie-ratings-ui

## TO DO:
* Users - Add ability to create a user account and store reviews per user
* Review Updates/Deletion - Add ability to update or delete reviews
* SSL - https does not work currently on heroku deployment

## Attributions
Movie data from [OMDb API](http://www.omdbapi.com/).

Default Film Reel image created by [OpenClipart-Vectors](https://pixabay.com/users/openclipart-vectors-30363) at [Pixabay](https://pixabay.com/).

## Project setup
Database setup:
```
psql
postgres=# create database movie_app_db;
postgres=# create user movie_app_user with encrypted password 'movie_app_password';
postgres=# grant all privileges on database movie_app_db to movie_app_user;
```
Sinatra setup:
```
bundle install
bundle exec rake db:migrate
```

To start the app locally, you will need to request an API key from [OMDb API](http://www.omdbapi.com/). To start the server with your API key:
```
OMDB_API_KEY=#### rackup
```

## Set up Vue.js UI
Instructions at https://github.com/kelsy/movie-ratings-ui
