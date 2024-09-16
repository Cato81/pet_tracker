class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :type
      t.string :tracker_type
      t.integer :owner_id
      t.boolean :in_zone
      t.boolean :lost_tracker, default: false

      t.timestamps
    end
  end
end
