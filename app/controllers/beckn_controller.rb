class BecknController < ApplicationController
  # GET /
  def index
    # noop
  end

  # POST /inbound_webhook/beckn
  def create
    record = InboundWebhook.create(body: request.body.read)

    # InboundWebhooks::BecknJob.perform_later(record)

    head :ok, json: {
      context: payload["context"],
      message: { ack: { status: 'ACK' } }
    }
  end
end
