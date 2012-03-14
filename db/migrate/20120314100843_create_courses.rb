class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :organisation
      t.integer :puavo_id
      t.integer :moodle_id

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
