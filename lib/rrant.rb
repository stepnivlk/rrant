require 'rrant/version'
require 'rrant/handler'

module Rrant
  def self.and(options = {})
    Handler.new(options = nil)
  end
end
