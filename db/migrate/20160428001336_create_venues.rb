class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :title
      t.string :headline
      t.text :description
      t.string :owner_type
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.decimal :latitude
      t.decimal :longitude
      t.string :url
      t.string :logo_url
      t.text :summary
      t.text :attractions
      t.text :photo_urls
      t.string :opening_date
      t.string :number_of_rooms
      t.string :theme
      t.string :total_gaming_space
      t.string :permanent_space
      t.string :casino_type
      t.string :owner
      t.datetime :renovated_at

      t.timestamps null: false
    end
  end
end
