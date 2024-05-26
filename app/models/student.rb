class Student < PupilfirstRecord
  has_one :school, through: :user
  belongs_to :cohort
  belongs_to :level, optional: true
  has_one :course, through: :cohort
  has_many :timeline_event_owners
  has_many :timeline_events, through: :timeline_event_owners
  belongs_to :pupilfirst_user, foreign_key: "user_id"

  def latest_submissions
    timeline_events.live.where(timeline_event_owners: {latest: true})
  end
end
