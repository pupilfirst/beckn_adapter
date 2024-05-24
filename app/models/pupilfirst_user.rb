class PupilfirstUser < PupilfirstRecord
  self.table_name = "users"

  has_many :students, foreign_key: "user_id"
  has_many :cohorts, through: :students
  has_one :coach, foreign_key: "user_id"
  belongs_to :school

  validates :name, presence: true

  scope :with_email, ->(email) { where("lower(email) = ?", email.downcase) }
end
