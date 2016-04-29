class AddCommentsToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :comments, :text, after: :description
  end
end
