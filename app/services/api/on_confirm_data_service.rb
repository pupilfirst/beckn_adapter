module Api
  class OnConfirmDataService
    def initialize(payload)
      @payload = payload
    end

    def execute
      # |30001|Provider not found|When BPP is unable to find the provider id sent by the BAP|
      return error_response("30001", "School not found") if school.blank?
      # |30004|Item not found|When BPP is unable to find the item id sent by the BAP|
      return error_response("30004", "Course not found") if course.blank?
      # |30008|Fulfillment unavailable|When BPP is unable to find the fulfillment id sent by the BAP|
      return error_response("30008", "Customer not found") if customer.blank?

      {
        message: {
          order: {
            id: order_id,
            provider: {
              id: school.id.to_s,
              descriptor: school.beckn_descriptor,
              categories: [],
              items: [course.beckn_item],
              fulfillments: [school.beckn_fullfillment_with_customer(customer)],
              quote: course.beckn_quote,
              billing: school.beckn_billing,
              payments: []
            }
          }
        }
      }
    end

    def order_id
      EncryptorService.new.encrypt(
        {
          bap_id: @payload["context"]["bap_id"],
          transaction_id: @payload["context"]["transaction_id"],
          student_id: student.id,
        }
      )
    end

    def student
      return unless customer

      name = customer["person"]["name"]
      email = customer["contact"]["email"]
      return if name.blank? || email.blank?

      @student ||= Lms::OnboardToCourseService.new(course, name, email).execute
    end

    def customer
      @customer = order["fulfillments"].first["customer"]
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
