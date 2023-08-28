# frozen_string_literal: true

module HalykEpay
  class Token
    URL = 'https://epay-oauth.homebank.kz'
    SCOPE = 'webapi usermanagement email_send verification statement statistics payment'
    GRANT_TYPE = 'client_credentials'

    class BadRequestError < StandardError; end

    attr_accessor :params

    def initialize(params = {})
      @params = params
    end

    def receive
      response = RestClient::Request.execute(
        method: :post,
        url: URL + '/oauth2/token',
        payload: base_token_params.merge(params),
        headers: { content_type: 'multipart/form-data' }
      )
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      raise BadRequestError, e.response
    end

    private

    def base_token_params
      {
        grant_type: GRANT_TYPE,
        scope: SCOPE,
        client_id: HalykEpay.client_id,
        client_secret: HalykEpay.client_secret,
      }
    end
  end
end
