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
  scope :registrable, -> { live.where(public_signup: true) }
  scope :archived, -> { where.not(archived_at: nil) }
  scope :access_active,
    -> {
      joins(:cohorts)
        .where("cohorts.ends_at > ? OR cohorts.ends_at IS NULL", Time.now)
        .distinct
    }
  scope :ended, -> { live.where.not(id: access_active) }
  scope :active, -> { live.access_active }
  belongs_to :default_cohort, class_name: "Cohort", optional: true

  PROGRESSION_BEHAVIOR_LIMITED = -"Limited"
  PROGRESSION_BEHAVIOR_UNLIMITED = -"Unlimited"
  PROGRESSION_BEHAVIOR_STRICT = -"Strict"

  def beckn_cohort
    return default_cohort if default_cohort.present?

    cohorts.active.first
  end

  def beckn_item
    {
      "id": id.to_s,
      "quantity": {
        "maximum": {
          "count": 1
        }
      },
      "descriptor": {
        "name": name,
        "short_desc": description.presence || "No description",
        "long_desc": about.presence || "No description",
        "images": [],
        "media": [
          {
            "url": "#{school.domains.primary.fqdn}/courses/#{id}"
          }
        ]
      },
      "creator": {
        "descriptor": {
          "name": school.name,
          "short_desc": school.about.presence || "No description",
          "long_desc": school.about.presence || "No description",
          "images": []
        }
      },
      "price": {
        "currency": "INR",
        "value": "0"
      },
      "category_ids": [],
      "rating": "5",
      "rateable": true,
      "tags": [
        {
          "descriptor": {
            "code": "content-metadata",
            "name": "Content metadata"
          },
          "list": highlights.map do |tag|
            {
              "descriptor": {
                "code": tag["title"].downcase.gsub(" ", "-"),
                "name": tag["title"]
              },
              "value": tag["description"].to_s
            }
          end,
          "display": true
        }
      ],
    }
  end

  def beckn_quote
    {
      price: {
        currency: "INR",
        value: "0"
      }
    }
  end
end
