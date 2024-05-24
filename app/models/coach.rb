class Coach < PupilfirstRecord
  self.table_name = "faculty"
  belongs_to :pupilfirst_user,
    class_name: "PupilfirstUser",
    foreign_key: "user_id"
  has_one :school, through: :user
  has_many :evaluated_events,
    class_name: "TimelineEvent",
    foreign_key: "evaluator_id",
    inverse_of: :evaluator,
    dependent: :nullify
  has_many :targets, dependent: :restrict_with_error
  has_many :faculty_cohort_enrollments,
    dependent: :destroy,
    foreign_key: "faculty_id"
  has_many :cohorts, through: :faculty_cohort_enrollments
  has_many :courses, through: :cohorts
end
