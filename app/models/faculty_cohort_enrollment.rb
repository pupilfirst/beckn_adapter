class FacultyCohortEnrollment < PupilfirstRecord
  belongs_to :coach, foreign_key: "faculty_id"
  belongs_to :cohort
end
