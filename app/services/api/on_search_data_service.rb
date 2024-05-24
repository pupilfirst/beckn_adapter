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
              "name": "Catalog for English courses"
            },
            "providers": @schools.joins(:domains).map do |school|
              courses = school.courses
              domain = school.domains.primary
              {
                "id": school.id.to_s,
                "descriptor": {
                  "name": school.name,
                  "short_desc": school.about.to_s || "No description",
                  "images": []
                },
                "categories": [],
                "items": courses.map do |course|
                  {
                    "id": course.id.to_s,
                    "quantity": {
                      "maximum": {
                        "count": 1
                      }
                    },
                    "descriptor": {
                      "name": course.name,
                      "short_desc": course.description.to_s,
                      "long_desc": course.about.to_s,
                      "images": [],
                      "media": [
                        {
                          "url": "#{domain.fqdn}/courses/#{course.id}"
                        }
                      ]
                    },
                    "creator": {
                      "descriptor": {
                        "name": school.name,
                        "short_desc": school.about.to_s,
                        "long_desc": school.about.to_s,
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
                        "list": course.highlights.map do |tag|
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
                end,
                "fulfillments": [
                  {
                    "agent": {
                      "person": {
                        "name": school.name
                      },
                      "contact": {
                        "email": 'todo@example.com'
                      }
                    }
                  }
                ]
              }
            end
          }
        }
      }
    end
  end
end
