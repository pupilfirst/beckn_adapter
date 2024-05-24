class TargetGroup < PupilfirstRecord
  has_many :targets, dependent: :restrict_with_error
  belongs_to :level
  has_one :course, through: :level
end
