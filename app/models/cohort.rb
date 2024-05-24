class Cohort < PupilfirstRecord
  belongs_to :course
  has_many :students, dependent: :destroy
  has_many :pupilfirst_users, through: :students

  has_many :faculty_cohort_enrollments, dependent: :destroy
  has_many :coaches,
    through: :faculty_cohort_enrollments,
    foreign_key: "faculty_id"
  has_one :school, through: :course

  scope :active,
    -> { where("ends_at > ?", Time.zone.now).or(where(ends_at: nil)) }
  scope :ended, -> { where("ends_at < ?", Time.zone.now) }

  def ended?
    ends_at.present? && ends_at.past?
  end
end
