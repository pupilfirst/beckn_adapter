module Api
  class OnSelectDataService
    def initialize(payload)
      order = payload["message"]["order"]
      item = order["items"].first

      @course = Course.registrable.find_by(id: item["id"])
      @school = @course.school
    end

    def execute
      # ToDo: Implement a generic NACK response
      return if @course.blank?
      {
        "message": {
          "order": {
            "provider": {
              "id": @school.id.to_s,
              "descriptor": @school.beckn_descriptor,
              "categories": [],
              "items": [@course.beckn_item],
              "fulfillments": [@school.beckn_fullfillment],
              "quote": @course.beckn_quote
            }
          }
        }
      }
    end
  end
end
