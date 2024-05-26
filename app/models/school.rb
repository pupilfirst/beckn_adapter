class School < PupilfirstRecord
  has_many :pupilfirst_users, dependent: :restrict_with_error
  has_many :courses, dependent: :restrict_with_error
  has_many :cohorts, through: :courses
  has_many :students, through: :pupilfirst_users
  has_many :coaches, through: :pupilfirst_users
  has_many :levels, through: :courses
  has_many :target_groups, through: :levels
  has_many :targets, through: :target_groups
  has_many :timeline_events, through: :students
  has_many :domains, dependent: :restrict_with_error
  has_many :school_strings, dependent: :restrict_with_error

  scope :live, -> { where(id: ENV["BECKN_ENABLED_SCHOOL_IDS"].split(",")) }

  def beckn_descriptor
    {
      name: name,
      short_desc: SchoolString::Description.for(self) || "Set a short description for your school in School Strings",
      images: []
    }
  end

  def beckn_fullfillment
    {
      agent: {
        person: {
          name: name
        },
        contact: {
          email: SchoolString::EmailAddress.for(self)
        }
      }
    }
  end

  def beckn_fullfillment_with_customer(customer)
    data = beckn_fullfillment
    data[:customer] = customer
    data
  end

  def beckn_billing
    {
      name: name,
      email: SchoolString::EmailAddress.for(self),
      address: SchoolString::Address.for(self)
    }
  end
end
