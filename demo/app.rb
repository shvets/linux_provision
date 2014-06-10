require 'sinatra'
require 'sinatra/activerecord'

require './note'
require './db_setup'

get "/" do
  @notes = Note.order("created_at DESC")
  redirect "/new" if @notes.empty?
  erb :index
end

get "/new" do
  erb :new
end

post "/new" do
  @note = Note.new(params[:note])
  if @note.save
    redirect "note/#{@note.id}"
  else
    erb :new
  end
end

get "/note/:id" do
  @note = Note.find_by_id(params[:id])
  erb :note
end