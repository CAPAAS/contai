# frozen_string_literal: true

require "contai/version"
require "contai/configuration"
require "contai/generatable"
require "contai/providers"
require "contai/engine" if defined?(Rails)

module Contai
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end