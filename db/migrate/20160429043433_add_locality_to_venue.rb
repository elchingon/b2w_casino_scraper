class AddLocalityToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :locality, :string, after: :district
  end
end
