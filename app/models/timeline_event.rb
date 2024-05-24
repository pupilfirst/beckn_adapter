class TimelineEvent < PupilfirstRecord
  belongs_to :target
  has_many :timeline_event_owners
  has_many :students, through: :timeline_event_owners
  has_many :pupilfirst_users, through: :students
  has_many :target_evaluation_criteria, through: :target
  has_many :evaluation_criteria, through: :target_evaluation_criteria

  scope :not_auto_verified, -> { joins(:target_evaluation_criteria).distinct }
  scope :auto_verified, -> { where.not(id: not_auto_verified) }
  scope :live, -> { where(archived_at: nil) }
  scope :passed, -> { where.not(passed_at: nil) }
end
