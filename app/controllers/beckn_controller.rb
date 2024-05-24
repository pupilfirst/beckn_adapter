class BecknController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /
  def index
    # noop
  end

  # POST /inbound_webhook/beckn
  def create
    record = InboundWebhook.create(body: payload)

    InboundWebhooks::BecknJob.perform_later(record)

    head :ok, json: {
      context: payload["context"],
      message: { ack: { status: 'ACK' } }
    }
  end

  private

  def payload
    @payload ||= request.body.read
  end
end
