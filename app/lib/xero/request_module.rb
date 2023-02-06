module Xero::RequestModule

  XERO_HOST = ENV["XERO_API_URL"]

  def api_request_post scenario_request, token, data=nil
    request = body_request(scenario_request, data)

    HTTParty.post(
        request[:url],
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        },
        body: request[:body].to_json
      )
  end

  def api_request_get scenario_request, token, data=nil
    HTTParty.get(
        path_request(scenario_request, data),
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      )
  end

  private

  def body_request scenario_request, data
    url = ENV["XERO_API_URL"] + scenario_request

    case scenario_request
    when "Invoices"
      return {url: url, body: invoice_body(data)}
    when "Invoices/{id}"
      url = url.gsub("{id}", data.xero_invoice_id)
      return {url: url, body: invoice_body(data)}
    end
  end

  def path_request scenario_request, data
    case scenario_request
    when "Invoices"
      return XERO_HOST + "Invoices"
    end
  end

  def invoice_body data
    line_items = Array.new

    data.transactions.order(id: :asc).each do |trans|
      item = {
        "Description": trans.description,
        "Quantity": trans.quantity,
        "UnitAmount": trans.unit_amount.to_s
      }

      item["LineItemID"] = trans.xero_line_item_id unless trans.xero_line_item_id.blank?

      line_items << item
    end

    return {
      "Type": "ACCPAY",
      "Contact": {
        "ContactID": ENV["XERO_CONTACT_ID"]
      },
      "Status": Invoice::XERO_PAYMENT_STATUSES[data.status],
      "CurrencyCode": "SGD",
      "DateString": data.issue_date,
      "DueDateString": data.due_date,
      "LineAmountTypes": "Exclusive",
      "LineItems": line_items
    }
  end

end