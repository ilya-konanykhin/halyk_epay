module HalykEpay
  class Payment
    URL = 'https://epay-api.homebank.kz/operation/'
    TEST_URL = 'https://testepay.homebank.kz/api/operation/'

    class BadRequestError < StandardError; end

    attr_accessor :token, :id

    def initialize(token, id)
      @token = token
      @id = id
    end

    def charge
      api_request("#{id}/charge")
    end

    def cancel
      api_request("#{id}/cancel")
    end

    private

    def api_request(path)
      responce = RestClient::Request.execute(
        method: :post,
        url: request_url + path,
        timeout: HalykEpay::TIMEOUT,
        headers: {Authorization: 'Bearer ' + token.access_token}
      )
      JSON.parse(responce.body)
    rescue RestClient::ExceptionWithResponse => e
      raise BadRequestError, e.response
    end

    def request_url
      HalykEpay.test_mode? ? TEST_URL : URL
    end
  end
end
