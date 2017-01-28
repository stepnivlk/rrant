require 'rrant/local'
require 'rrant/remote'
require 'rrant/store'

module Rrant
  class Handler
    def initialize(options = nil)
      @options = options || Hash.new(false)
      @store = Store.new
    end

    def rave
      local.unseen(@unseen).random
    end

    def dos
      Thread.new { remote.save }
      self
    end

    def and
      self
    end

    def unseen(visible = true)
      @unseen = visible
      self
    end

    def delete(due_date = 30)
      @due_date = due_date
      self
    end

    private

    def remote
      @remote ||= Remote.new(@store)
    end

    def local
      @local ||= Local.new(@store)
    end
  end
end
