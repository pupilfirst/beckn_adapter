module Api
  class OnSelectDataService
    def initialize(payload)
      @payload = payload
    end

    def execute
      # |30001|Provider not found|When BPP is unable to find the provider id sent by the BAP|
      return error_response("30001", "School not found") if school.blank?
      # |30004|Item not found|When BPP is unable to find the item id sent by the BAP|
      return error_response("30004", "Course not found") if course.blank?

      {
        "message": {
          "order": {
            "provider": {
              "id": school.id.to_s,
              "descriptor": school.beckn_descriptor,
              "categories": [],
              "items": [course.beckn_item],
              "fulfillments": [school.beckn_fullfillment],
              "quote": course.beckn_quote
            }
          }
        }
      }
    end

    def course
      @course ||= school.courses.registrable.find_by(id: order["items"].first["id"])
    end

    def school
      @school ||= School.live.find_by(id: order["provider"]["id"])
    end

    def order
      @order = @payload["message"]["order"]
    end

    def error_response(code, message)
      Api::ErrorDataService.new.data(code, message)
    end
  end
end
