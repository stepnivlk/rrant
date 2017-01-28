require 'rrant/version'
require 'rrant/handler'
require 'httparty'
require 'catpix'
require 'pstore'
require 'open-uri'

module Rrant
  def self.and(options = {})
    Handler.new(options = nil)
  end
end
