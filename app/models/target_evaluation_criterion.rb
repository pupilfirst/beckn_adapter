class TargetEvaluationCriterion < PupilfirstRecord
  belongs_to :target
  belongs_to :evaluation_criterion

  validates :target_id, uniqueness: {scope: :evaluation_criterion_id}
end
