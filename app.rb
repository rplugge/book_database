require "sqlite3"
require "sinatra"
require "sinatra/reloader"
require "pry"

require_relative "book.rb"
require_relative "genre.rb"
require_relative "location.rb"
require_relative "module.rb"
require_relative "instance_module.rb"


CONNECTION = SQLite3::Database.new("inventory.db")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS books (id INTEGER PRIMARY KEY, name TEXT NOT NULL, genre_id INTEGER NOT NULL, location_id INTEGER NOT NULL, quantity INTEGER NOT NULL, FOREIGN KEY(location_id) REFERENCES locations(id), FOREIGN KEY(genre_id) REFERENCES genres(id));")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS genres (id INTEGER PRIMARY KEY, name TEXT NOT NULL);")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS locations (id INTEGER PRIMARY KEY, name TEXT NOT NULL);")

# Get results as an Array of Hashes.
CONNECTION.results_as_hash = true

# ------------------------------------------------------------

# - Homepage
#
# - Displays the homepage (links to /books, /genres, /locations, /search)
get "/home" do
  erb :"homepage"
end

# - Book options page
#
# - Links to /add_book, /edit_book, /delete_book
get "/books" do
  erb :"books_page"
end

# - Add Book ------------------
# 
# - Book information form
#
# - Accepts inputs for book information to add to database.
# - Links to /save_book
get "/add_book" do
  erb :"add_book_form"
end

# - Creates book object, checks to see if valid, adds row to database.
#
# - links back to homepage or displays fail text.
get "/save_book" do
  new_book = Book.new({"name" => params["name"], "genre_id" => params["genre_id"].to_i, "location_id" => params["location_id"].to_i, "quantity" => params["quantity"].to_i})
  
  if new_book.valid?
    Book.add({"name" => params["name"], "genre_id" => params["genre_id"].to_i, "location_id" => params["location_id"].to_i, "quantity" => params["quantity"].to_i})
    erb :"homepage"
  else
    "Sorry, wasn't able to add to database at this time."
  end
end
# -------------------------------

# - Edit Book -------------------------
#
# - List of books that can be edited, links to /edit_book/:id
get "/edit_book" do
  erb :"edit_book"
end

# - Displays a drop-down menu for editable attributes of a book.
#
# - Links to /change_book/:id
get "/edit_book/:id" do
  erb :"edit_book_list"
end

# - Creates book object and updates assosiated column with the new information.
#
# - Links back to /home
get "/change_book/:id" do
  column = params["edit_choice"]
  
  book_object = Book.find(params["id"].to_i)
  book_object.send("#{column}=", params["new_input"])
  book_object.save
  
  erb :"homepage"
end


get "/delete_book" do
  erb :"delete_book"
end

get "/delete_book_object/:id" do
  this_book = Book.find(params[:id].to_i)
  
  this_book.delete
  
  erb :"homepage"
end

# ---------------- Genres ------------------------------------
# ------------------------------------------------------------

get "/genres" do
  erb :"genres_page"
end

get "/add_genre" do
  erb :"add_genre_form"
end

get "/save_genre" do
  new_genre = Genre.new({"name" => params["name"]})
  
  if new_genre.valid?
    Genre.add({"name" => params["name"]})
    erb :"homepage"
  else
    "Sorry, wasn't able to add to database at this time."
  end
end


get "/delete_genre" do
  erb :"delete_genre"
end

get "/delete_genre_object/:id" do
  this_genre = Genre.find(params[:id].to_i)
  
  this_genre.delete
  
  erb :"homepage"
end

# ---------------------------- Locations ----------------------------
#--------------------------------------------------------------------

get "/locations" do
  erb :"locations_page"
end

get "/add_location" do
  erb :"add_location_form"
end

get "/save_location" do
  new_location = Location.new({"name" => params["name"]})
  
  if new_location.valid?
    Location.add({"name" => params["name"]})
    erb :"homepage"
  else
    "Sorry, wasn't able to add to database at this time."
  end
end


get "/delete_location" do
  erb :"delete_location"
end

get "/delete_location_object/:id" do
  this_location = Location.find(params[:id].to_i)
  
  this_location.delete
  
  erb :"homepage"
end

# ----------------------------- Search ---------------------------------
# ----------------------------------------------------------------------

get "/search" do
  erb :"search_list"
end

get "/search_genre" do
  erb :"search_genre"
end

get "/search_genre/:id" do
  erb :"search_return_genre"
end

get "/search_location" do
  erb :"search_location"
end

get "/search_location/:id" do
  erb :"search_return_location"
end