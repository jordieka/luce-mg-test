module Xero::ResponseModule

  def json_response(result)
    if result["Status"].eql?("OK")
      return { data: set_result(result), meta: set_meta }
    else
      message = result["Message"] || result["Title"]
      errors = result["Detail"] || result["Elements"]["ValidationErrors"]
      status = result["Status"].kind_of?(Integer) ? result["Status"] : Rack::Utils::SYMBOL_TO_STATUS_CODE.key(result["Status"].downcase.to_sym) rescue 422

      return { data: {}, meta: set_meta(message: message, error_code: status, errors: errors) }
    end
  end

  private

  def set_result(result)
    result = result || {}
  end

  def set_meta(message: "Success", error_code: nil, errors: nil)
    code = error_code.blank? ? 200 : error_code

    response = {
      "code": code,
      "message": message,
      "errors": errors
    }
  end

  def get_status_code(status)
    return 500 if status.blank?
    Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
  end

  def set_status_response(status_code)
    status_code.blank?
  end

end