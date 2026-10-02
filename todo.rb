require "sinatra"
require "sinatra/reloader"
require "tilt/erubi"
require "sinatra/content_for"
configure do # activate session support
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

before do
  session[:lists] ||= [] # lists is an array of hashes, each hash represents a list
end

# URL's names should be resource based
get "/" do
  redirect "/lists"
end

# View list of lists
get "/lists" do
    @lists = session[:lists]
    erb :lists, layout: :layout #pulling the lists out of the session
end

# Render the new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

# Return an error message if the name is invalid. Return nil if the name is valid.
def error_for_list_name(name)
  if !(1..100).cover?(name.size)
    "List name must be between 1 and 100 characters."
  elsif session[:lists].any?{|list| list[:name] == name}
    "List name must be unique."
  else # return nil
  end
end
# Create a new list
post "/lists" do
  list_name = params[:list_name].strip
  error = error_for_list_name(list_name)

  if error  # set to nil or error message
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << {name: list_name, todos:[]}
    session[:success] = "The list has been created." # we want to create the session key here to use in lists
    redirect "/lists"
    end
end

get "/lists/:id" do
  @id = params[:id].to_i
  @list = session[:lists][@id]
  erb :list, layout: :layout
end

# Edit an existing todo list
get "/lists/:id/edit" do
  @id = params[:id].to_i
  @list = session[:lists][@id]
  erb :edit_list, layout: :layout
end

# Update an existing todo list
post "/lists/:id" do
  list_name = params[:list_name].strip
  @id = params[:id].to_i
  @list = session[:lists][@id]

  error= error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @list[:name] = list_name
    session[:success] = "The list has been updated."
    redirect "/lists/#{@id}"
  end
end

#Delete a todo list
post "/lists/:index/delete" do
  @list = session[:lists][@id]
end

post "/lists/:index/new" do
hi
end