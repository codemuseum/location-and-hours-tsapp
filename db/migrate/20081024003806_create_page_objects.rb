class CreatePageObjects < ActiveRecord::Migration
  def self.up
    create_table :page_objects do |t|
      t.string :urn
      t.string :name
      t.string :street_line1
      t.string :street_line2
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :phone
      t.string :fax
      t.string :link
      t.string :time_zone
      t.text :location_note
      t.boolean :monday_closed
      t.time :monday_opens
      t.time :monday_closes
      t.boolean :tuesday_closed
      t.time :tuesday_opens
      t.time :tuesday_closes
      t.boolean :wednesday_closed
      t.time :wednesday_opens
      t.time :wednesday_closes
      t.boolean :thursday_closed
      t.time :thursday_opens
      t.time :thursday_closes
      t.boolean :friday_closed
      t.time :friday_opens
      t.time :friday_closes
      t.boolean :saturday_closed
      t.time :saturday_opens
      t.time :saturday_closes
      t.boolean :sunday_closed
      t.time :sunday_opens
      t.time :sunday_closes
      t.text :hours_note

      t.timestamps
    end
  end

  def self.down
    drop_table :page_objects
  end
end
