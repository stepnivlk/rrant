require 'rrant/version'
require 'rrant/handler'

# Public: Main interface to application logic, delegates to 'Handler'.
module Rrant
  def self.and
    Handler.new
  end
end
