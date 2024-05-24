require 'net/http'
require 'json'

# School.configurations.beckn
# {
#   "bpp_id": "pupilfirst-bpp",
#   "bpp_uri": "https://bodhi.loca.lt"
# }
#

class BecknRespondService
  def initialize(school, payload)
    @school = school
    @payload = payload
    @bpp_config = school.configuration['beckn']
  end

  def execute(action, response)
    data = { context: build_context(action), **response }

    response = send_post_request(end_point(action), data)
    handle_response(response)
  end

  private

  def end_point(action)
    # example http://localhost:6001/on_search
    ENV['BPP_CLIENT_URI'] + '/' + action
  end

  def build_context(action)
    context = @payload['context'].dup
    context.delete('action')
    context.merge!(
      bpp_id: @bpp_config['bpp_id'],
      bpp_uri: @bpp_config['bpp_uri'],
      action: action
    )

    context
  end

  def send_post_request(url, payload)
    uri = URI(url)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = payload.to_json

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
  end

  def handle_response(response)
    if response.is_a?(Net::HTTPSuccess)
      puts "Request was successful."
      puts response.body
    else
      puts "Request failed: #{response.code} #{response.message}"
    end
    response
  end
end
