class PupilfirstUser < PupilfirstRecord
  self.table_name = "users"

  has_many :students, foreign_key: "user_id"
  has_many :cohorts, through: :students
  has_one :coach, foreign_key: "user_id"
  belongs_to :school

  validates :name, presence: true

  scope :with_email, ->(email) { where("lower(email) = ?", email.downcase) }

  def regenerate_login_token
    @original_login_token = SecureRandom.urlsafe_base64
    update!(
      login_token_digest: Digest::SHA2.base64digest(@original_login_token),
      login_token_generated_at: Time.zone.now
    )
  end

  def original_login_token
    @original_login_token || raise("Original login token is unavailable")
  end
end
