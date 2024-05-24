require 'net/http'
require 'json'

module InboundWebhooks
  class BecknJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!
      payload = JSON.parse(inbound_webhook.body)
      data = Api::OnSearchDataService.new(School.all).execute
      response = BecknRespondService.new(School.first, payload).execute('on_search', data)

      # Handle the response
      if response.is_a?(Net::HTTPSuccess)
        # Handle successful response
        inbound_webhook.processed!
      else
        # Handle failed response
        inbound_webhook.failed!
      end
      # Or mark as failed and re-enqueue the job
      # inbound_webhook.failed!
    end
  end
end
