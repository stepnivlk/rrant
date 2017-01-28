require 'rrant/version'
require 'rrant/store'
require 'httparty'
require 'catpix'
require 'pstore'
require 'open-uri'

module Rrant
  def self.and(options = {})
    Store.new(options = nil)
  end
end
