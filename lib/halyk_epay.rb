# frozen_string_literal: true

require "halyk_epay/version"
require 'halyk_epay/token'
require 'halyk_epay/payment'

module HalykEpay
  CONFIGURABLE_ATTRIBUTES = [:client_id, :client_secret, :terminal_id]

  DEFAULTS = {
    # test data - https://epayment.kz/docs/Test%20credentials
    client_id: "test",
    client_secret: "yF587AV9Ms94qN2QShFzVR3vFnWkhjbAK3sG",
    terminal_id: '67e34d63-102f-4bd1-898e-370781d0074d',
    test_mode?: true,
  }.freeze

  module Configurator
    require 'active_support/core_ext/module/attribute_accessors'

    def configure_for_test
      configure(DEFAULTS)
    end

    def configure(attrs = {})
      attrs.each do |k, v|
        self.send(:"#{k}=", v) if CONFIGURABLE_ATTRIBUTES.include?(k.to_sym)
      end
      yield self if block_given?

      if (blank = CONFIGURABLE_ATTRIBUTES.map { |att| [att, self.send(att)] }.select{ |_, val| val.nil? }).count > 0
        blank_attribute_names = blank.map { |attr, _| attr }.join(", ")
        raise "Some required attributes left blank: #{blank_attribute_names}"
      end

      self
    end

    CONFIGURABLE_ATTRIBUTES.each do |att|
      mattr_accessor att
    end
  end

  extend Configurator
end
