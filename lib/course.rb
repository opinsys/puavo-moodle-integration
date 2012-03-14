class Course < ActiveRecord::Base
  validates_uniqueness_of :puavo_id, :scope => :moodle_id
end
