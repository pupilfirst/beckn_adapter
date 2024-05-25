module Api
  class OnConfirmDataService
    def initialize(payload)
      order = payload["message"]["order"]
      item = order["items"].first
      @customer = order["fulfillments"].first
      # course data
      @course = Course.registrable.find_by(id: item["id"])
      @school = @course.school
    end

    def execute
      # ToDo: Implement a generic NACK response
      return if @course.blank?
      {
        message: {
          order: {
            id: "1234",
            provider: {
              id: @school.id.to_s,
              descriptor: @school.beckn_descriptor,
              categories: [],
              items: [@course.beckn_item],
              fulfillments: [@school.beckn_fullfillment_with_customer(@customer)],
              quote: @course.beckn_quote,
              billing: @school.beckn_billing,
              payments: []
            }
          }
        }
      }
    end
  end
end
