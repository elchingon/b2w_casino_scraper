class AddTicketmasterEventIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :ticketmaster_event_id, :string
  end
end
