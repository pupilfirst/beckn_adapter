class Level < PupilfirstRecord
  has_many :target_groups, dependent: :restrict_with_error
  has_many :students, dependent: :restrict_with_error
  has_many :targets, through: :target_groups
  has_many :timeline_events, through: :targets

  scope :unlocked,
    -> { where(unlock_at: nil).or(where("unlock_at <= ?", Time.zone.now)) }

  belongs_to :course
end
