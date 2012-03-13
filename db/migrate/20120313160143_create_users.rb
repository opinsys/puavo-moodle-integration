class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :organisation
      t.integer :puavo_id
      t.integer :moodle_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
