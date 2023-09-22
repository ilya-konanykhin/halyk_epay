# frozen_string_literal: true

module HalykEpay
  class Token
    URL = 'https://epay-oauth.homebank.kz/oauth2/token'
    TEST_URL = 'https://testoauth.homebank.kz/epay2/oauth2/token'
    SCOPE = 'webapi usermanagement email_send verification statement statistics payment'
    GRANT_TYPE = 'client_credentials'

    class BadRequestError < StandardError; end

    attr_accessor :token

    def initialize(params = {})
      @token = api_request(params)
    end

    def access_token
      token["access_token"]
    end

    private

    def api_request(params)
      response = RestClient::Request.execute(
        method: :post,
        timeout: HalykEpay::TIMEOUT,
        url: request_url,
        payload: base_token_params.merge(params),
        headers: { content_type: 'multipart/form-data' }
      )
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      raise BadRequestError, e.response
    end

    def base_token_params
      {
        grant_type: GRANT_TYPE,
        scope: SCOPE,
        client_id: HalykEpay.client_id,
        client_secret: HalykEpay.client_secret,
      }
    end

    def request_url
      HalykEpay.test_mode? ? TEST_URL : URL
    end
  end
end
