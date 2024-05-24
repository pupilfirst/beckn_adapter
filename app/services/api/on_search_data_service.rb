module Api
  class OnSearchDataService
    def initialize(schools)
      @schools = schools
    end

    def execute
      {
        "message": {
          "catalog": {
            "descriptor": {
              "name": "Course Catalog"
            },
            "providers": @schools.joins(:domains).map do |school|
              {
                "id": school.id.to_s,
                "descriptor": school.beckn_descriptor,
                "categories": [],
                "items": school.courses.registrable.map { |course| course.beckn_item },
                "fulfillments": [school.beckn_fullfillment]
              }
            end
          }
        }
      }
    end
  end
end
