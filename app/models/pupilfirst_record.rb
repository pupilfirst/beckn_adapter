class PupilfirstRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: {writing: :pupilfirst}
end
