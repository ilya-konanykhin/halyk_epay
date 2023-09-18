module HalykEpay
  class Transaction
    URL = 'https://epay-api.homebank.kz/'
    TEST_URL = 'https://testepay.homebank.kz/api/'
    SUCCESS_REQUEST_CODE = 100
    INITIAL_REQUEST_CODE = 107
    SUCCESS_AMOUNT_STATUS = 'AUTH'
    CHARGE_AMOUNT_STATUS = 'CHARGE'
    INITIAL_TRANSACTION_STATUS = 'NEW'
    FAILED_TRANSACTION_STATUS = %w(REJECT 3D FAILED CANCEL_OLD CANCEL)

    class BadRequestError < StandardError; end

    attr_accessor :data, :token, :id

    def initialize(token, id)
      @token = token
      @id = id
      @data = {}
    end

    def receive
      @data = api_request("check-status/payment/transaction/#{id}")
    end

    # Код транзакции показывает успех выполнения запроса. Если в ответ приходит:
    # - 100, необходимо смотреть поле transaction_data['statusName'] для получения статуса транзакции.
    # - 107, операция в процессе выполнения, запросить статус позже
    # В остальных случаях запрос неуспешен. Подробнее - https://epayment.kz/docs/status-tranzakcii
    def code
      data['resultCode']
    end

    def message
      data['resultMessage']
    end

    def transaction_data
      data['transaction'] || {}
    end

    def in_progress?
      code == INITIAL_REQUEST_CODE || transaction_data['statusName'] == INITIAL_TRANSACTION_STATUS
    end

    def success?
      code == SUCCESS_REQUEST_CODE && [SUCCESS_AMOUNT_STATUS, CHARGE_AMOUNT_STATUS].include?(transaction_data['statusName'])
    end

    def failed?
      FAILED_TRANSACTION_STATUS.include?(transaction_data['statusName'])
    end

    def amount_charged?
      transaction_data['statusName'] == CHARGE_AMOUNT_STATUS
    end

    private

    def api_request(path)
      url = HalykEpay.test_mode? ? TEST_URL : URL
      responce = RestClient::Request.execute(
        method: :get,
        url: url + path,
        headers: {Authorization: 'Bearer ' + token.access_token}
      )
      JSON.parse(responce.body)
    rescue RestClient::ExceptionWithResponse => e
      raise BadRequestError, e.response
    end
  end
end


