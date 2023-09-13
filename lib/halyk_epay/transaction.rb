module HalykEpay
  class Transaction
    SUCCESS_REQUEST_CODE = 100
    INITIAL_REQUEST_CODE = 107
    SUCCESS_AMOUNT_STATUS = 'AUTH'
    CHARGE_AMOUNT_STATUS = 'CHARGE'
    INITIAL_TRANSACTION_STATUS = 'NEW'
    FAILED_TRANSACTION_STATUS = %w(REJECT 3D FAILED CANCEL_OLD CANCEL)

    class BadRequestError < StandardError; end

    attr_accessor :data

    def initialize(data)
      @data = data
    end

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
  end
end


