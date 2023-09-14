# frozen_string_literal: true

require 'halyk_epay/transaction'

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
      transaction = get_request("https://testepay.homebank.kz/api/check-status/payment/transaction/#{id}")
      HalykEpay::Transaction.new(transaction)
    end

    def charge
      post_request("operation/#{id}/charge")
    end

    def cancel
      post_request("operation/#{id}/cancel")
    end

    private

    def api_request(path, method)
      responce = RestClient::Request.execute(
        method: method,
        url: URL + path,
        headers: { Authorization: 'Bearer ' + token['access_token'] }
      )
      JSON.parse(responce.body)
    rescue RestClient::ExceptionWithResponse => e
      raise BadRequestError, e.response
    end

    def post_request(path)
      api_request(path, :post)
    end

    def get_request(path)
      api_request(path, :get)
    end
  end
end
