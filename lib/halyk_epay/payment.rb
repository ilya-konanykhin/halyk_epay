# frozen_string_literal: true

module HalykEpay
  class Payment
    URL = 'https://epay-api.homebank.kz/'

    class BadRequestError < StandardError; end

    attr_accessor :token, :id

    def initialize(token, id)
      @token = token
      @id = id
    end

    def receive
      api_request("check-status/payment/transaction/#{id}")
    end

    def charge
      api_request("operation/#{id}/charge")
    end

    def cancel
      api_request("operation/#{id}/cancel")
    end

    def refund
      api_request("operation/#{id}/refund")
    end

    private

    def api_request(path)
      responce = RestClient::Request.execute(
        method: :post,
        url: URL + path,
        headers: { Authorization: 'Bearer ' + token }
      )
      JSON.parse(responce.body)
    rescue RestClient::ExceptionWithResponse => e
      raise BadRequestError, e.response
    end
  end
end
