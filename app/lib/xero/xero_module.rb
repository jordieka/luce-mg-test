require "uri"
require "net/http"

module Xero::XeroModule

  def get_access_token
    encoded = Base64.strict_encode64(ENV["XERO_CLIENT_ID"] + ":" + ENV["XERO_CLIENT_SECRET"])

    url = URI("https://identity.xero.com/connect/token")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request["Authorization"] = "Basic #{encoded}"
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=client_credentials&scopes=accounting.transactions"
    
    response = https.request(request)

    return JSON.parse(response.read_body)["access_token"]
  end
end