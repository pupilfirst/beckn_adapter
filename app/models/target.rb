class Target < PupilfirstRecord
  has_many :timeline_event
  belongs_to :target_group
  has_one :level, through: :target_group
  has_one :course, through: :level
  has_many :target_evaluation_criteria, dependent: :destroy
  has_many :assignments, dependent: :restrict_with_error

  VISIBILITY_LIVE = "live"
  VISIBILITY_ARCHIVED = "archived"
  VISIBILITY_DRAFT = "draft"

  scope :live, -> { where(visibility: VISIBILITY_LIVE) }
  scope :not_auto_verified, -> { joins(:target_evaluation_criteria).distinct }
  scope :auto_verified, -> { where.not(id: not_auto_verified) }

  scope :milestone,
    -> do
      joins(:assignments).where(
        assignments: {
          milestone: true,
          archived: false
        }
      )
    end

  def milestone?
    assignments.where(milestone: true, archived: false).exists?
  end
end
