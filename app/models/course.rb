class Course < PupilfirstRecord
  has_many :levels
  has_many :cohorts, dependent: :restrict_with_error
  has_many :students, through: :cohorts
  has_many :users, through: :students
  has_many :pupilfirst_users, through: :students
  has_many :target_groups, through: :levels
  has_many :targets, through: :target_groups
  has_many :timeline_events, through: :targets
  has_many :coaches, -> { distinct }, through: :cohorts

  belongs_to :school

  scope :featured, -> { where(featured: true) }
  scope :live, -> { where(archived_at: nil) }
  scope :public_signup, -> { live.where(public_signup: true) }
  scope :archived, -> { where.not(archived_at: nil) }
  scope :access_active,
    -> {
      joins(:cohorts)
        .where("cohorts.ends_at > ? OR cohorts.ends_at IS NULL", Time.now)
        .distinct
    }
  scope :ended, -> { live.where.not(id: access_active) }
  scope :active, -> { live.access_active }

  PROGRESSION_BEHAVIOR_LIMITED = -"Limited"
  PROGRESSION_BEHAVIOR_UNLIMITED = -"Unlimited"
  PROGRESSION_BEHAVIOR_STRICT = -"Strict"
end
