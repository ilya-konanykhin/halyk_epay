# frozen_string_literal: true

module HalykbankEpay
  class Transaction
    SUCCESS_AMOUNT_STATUS = 'CHARGE'
    BLOCK_AMOUNT_STATUS = 'AUTH'
    DEBITED_AMOUNT_STATUS = 'CHARGE'
    INITIAL_TRANSACTION_STATUS = 'NEW'
    RETRY_REQUEST_STATUS = 107
    FAILED_TRANSACTION_STATUS = %w(REJECT 3D FAILED CANCEL_OLD CANCEL)

    class BadRequestError < StandardError; end

    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def status
      data['transaction']['statusName']
    end

    def success?
      data['transaction'] && data['transaction']['statusName'] == SUCCESS_AMOUNT_STATUS
    end

    def failed?
      data['transaction'] && FAILED_TRANSACTION_STATUS.include?(data['transaction']['statusName'])
    end

    def retry_late?
      data['resultCode'] == RETRY_REQUEST_STATUS || (data['transaction'] && data['transaction']['statusName'] == INITIAL_TRANSACTION_STATUS)
    end

    def can_confirm?
      can_update?
    end

    def can_cancel?
      can_update?
    end

    def can_refund?
      data['transaction'] && data['transaction']['statusName'] == DEBITED_AMOUNT_STATUS
    end

    private

    def can_update?
      data['transaction'] && data['transaction']['statusName'] == BLOCK_AMOUNT_STATUS
    end
  end
end


