class School < PupilfirstRecord
  has_many :pupilfirst_users, dependent: :restrict_with_error
  has_many :courses, dependent: :restrict_with_error
  has_many :cohorts, through: :courses
  has_many :students, through: :pupilfirst_users
  has_many :coaches, through: :pupilfirst_users
  has_many :levels, through: :courses
  has_many :target_groups, through: :levels
  has_many :targets, through: :target_groups
  has_many :timeline_events, through: :students
  has_many :domains, dependent: :restrict_with_error
end
