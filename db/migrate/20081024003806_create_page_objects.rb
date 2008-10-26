class CreatePageObjects < ActiveRecord::Migration
  def self.up
    create_table :page_objects do |t|
      t.string :urn
      t.string :name
      t.string :time_zone
      
      t.string :street_line1
      t.string :street_line2
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      
      t.string :email
      t.string :phone
      t.string :fax
      t.string :link
      
      t.text :location_note
      
      t.boolean :sunday_closed, :null => false, :default => false
      t.time :sunday_opens
      t.time :sunday_closes
      t.boolean :monday_closed, :null => false, :default => false
      t.time :monday_opens
      t.time :monday_closes
      t.boolean :tuesday_closed, :null => false, :default => false
      t.time :tuesday_opens
      t.time :tuesday_closes
      t.boolean :wednesday_closed, :null => false, :default => false
      t.time :wednesday_opens
      t.time :wednesday_closes
      t.boolean :thursday_closed, :null => false, :default => false
      t.time :thursday_opens
      t.time :thursday_closes
      t.boolean :friday_closed, :null => false, :default => false
      t.time :friday_opens
      t.time :friday_closes
      t.boolean :saturday_closed, :null => false, :default => false
      t.time :saturday_opens
      t.time :saturday_closes
      
      t.text :hours_note

      t.timestamps
    end
    add_index :page_objects, :urn
  end

  def self.down
    drop_table :page_objects
  end
end
