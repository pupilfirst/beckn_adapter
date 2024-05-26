# Adapted from: https://github.com/beckn/protocol-specifications/blob/master/docs/BECKN-005-Error-Codes-Draft-01.md
module Api
  class ErrorDataService
    def data(code, message)
      {
        message: {
          ack: {
            status: "NACK"
          }
        },
        error: {
          type: "DOMAIN-ERROR",
          code: code,
          message: message
        }
      }
    end
  end
end
