require 'net/http'
require 'json'

module InboundWebhooks
  class BecknJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!
      payload = JSON.parse(inbound_webhook.body)

      action = payload["context"]["action"]

      case action
      when "search"
        data = Api::OnSearchDataService.new(School.all).execute
        response = BecknRespondService.new(School.first, payload).execute('on_search', data)
      when "select"
        data = Api::OnSelectDataService.new(payload).execute
        response = BecknRespondService.new(School.first, payload).execute('on_select', data)
      when "init"
        data = Api::OnInitDataService.new(payload).execute
        response = BecknRespondService.new(School.first, payload).execute('on_init', data)
      else
        # Handle unknown action
        inbound_webhook.failed!
        return
      end

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
