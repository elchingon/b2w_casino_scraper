class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :venue_id
      t.integer :parent_event_id
      t.integer :locality_id
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :link_url
      t.string :image_url
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7

      t.timestamps null: false
    end
  end
end
