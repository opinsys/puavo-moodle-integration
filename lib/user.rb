class User < ActiveRecord::Base
  default_scope { where(:organisation => Thread.current["organisation"]) }

  validates_uniqueness_of :puavo_id, :scope => :moodle_id
end
