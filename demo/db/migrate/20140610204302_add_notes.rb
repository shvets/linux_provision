class AddNotes < ActiveRecord::Migration
  def change
    Note.create :title => "Title 1", :body => "some body 1"
    Note.create :title => "Title 2", :body => "some body 2"
    Note.create :title => "Title 3", :body => "some body 3"
  end
end
