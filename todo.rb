require "sinatra"
<<<<<<< HEAD
require "sinatra/reloader" if development? 
require "tilt/erubi"
require "sinatra/content_for"
configure do # activate session support
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

helpers do # any method we write here is going to be accessible in any view templates we have and in all of the routes
  def list_complete?(list)
     todos_count(list) > 0 && todos_remaining_count(list) == 0
  end

  def list_class(list)
    "complete" if list_complete?(list)
  end

  def todos_count(list)
    list[:todos].size
  end

  def todos_remaining_count(list)
    list[:todos].count {|todo| todo[:completed] != true}
  end

  def sort_lists(lists, &block)
    complete_lists, incomplete_lists = lists.partition {|list| list_complete?(list)}

    incomplete_lists.each {|list| yield list, lists.index(list)}
    complete_lists.each {|list| yield list, lists.index(list)}
  end

  def sort_todos(todos, &block)
    incomplete_todos = {}
    complete_todos = {}

    todos.each_with_index do |todo, index|
      if todo[:completed]
        complete_todos[todo] = index
      else
        incomplete_todos[todo] = index
      end
    end
    incomplete_todos.each(&block)
    complete_todos.each(&block)
  end
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

def error_for_todo(name)
  if !(1..100).cover?(name.size)
    "Todo must be between 1 and 100 characters."
  else
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
  @list_id = params[:id].to_i
  @list = session[:lists][@list_id]
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
post "/lists/:id/delete" do
  @id = params[:id].to_i
  session[:lists].delete_at(@id)
  session[:success] = "The list has been deleted."
  redirect "/lists"
end

#Add a new todo to a list
post "/lists/:list_id/todos" do
  @list_id = params[:list_id].to_i
  @list = session[:lists][@list_id]
  text = params[:todo].strip

  error = error_for_todo(text)
  if error
    session[:error] = error
    erb :list, layout: :layout
  else
    @list[:todos] << {name: text, completed: false}
    session[:success] = "The todo was added."
    redirect "/lists/#{@list_id}"
  end
end

# Delete a todo from a list
post "/lists/:list_id/todos/:todo_id/delete" do
  @list_id = params[:list_id].to_i
  @list = session[:lists][@list_id]

  @todo_id = params[:todo_id].to_i
  @list[:todos].delete_at(@todo_id)
  session[:success] = "The todo was deleted."
  redirect "/lists/#{@list_id}"
end

# Update the status of a todo
post "/lists/:list_id/todos/:todo_id" do
  @list_id = params[:list_id].to_i
  @list = session[:lists][@list_id]

  @todo_id = params[:todo_id].to_i
  is_completed = params[:completed] == "true" # returns true or false
  @list[:todos][@todo_id][:completed] = is_completed

  session[:success] = "The todo has been updated."
  redirect "/lists/#{@list_id}"
end


# Mark all todos as complete for a list
post "/lists/:list_id/complete_all" do
  @list_id = params[:list_id].to_i
  @list = session[:lists][@list_id]

  @list[:todos].each do |todo|
    todo[:completed] = true
  end

  session[:success] = "All todos have been completed"
  redirect "/lists/#{@list_id}"
end


# All of the todo items are completed
# It has one todo item
=======
require "sinatra/reloader"
require "tilt/erubi"

get "/" do
  erb "You have no lists.", layout: :layout
end
>>>>>>> f85f18fbf5f2b9228093b9e537b027bfdb5853cc
