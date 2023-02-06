require 'httparty'

class Xero::InvoiceServices

  include Xero::XeroModule
  include Xero::RequestModule
  include Xero::ResponseModule

  def initialize
    @token = get_access_token
  end

  def create_invoice(invoice)
    request = api_request_post("Invoices", @token, invoice)
    json_response(JSON.parse(request.body))
  end

  def update_invoice(invoice)
    request = api_request_post("Invoices/{id}", @token, invoice)
    json_response(JSON.parse(request.body))
  end

end