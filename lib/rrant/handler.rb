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
      cache.unseen(@unseen).random
    end

    def dos(sort = :algo, amount = 10)
      Thread.new { remote.fetch(sort, amount) }
      self
    end

    def and
      self
    end

    def unseen
      @unseen = true
      self
    end

    def log
      @log = true
      self
    end

    def delete(due_date = 30)
      @format = due_date
      self
    end

    private

    def remote
      @remote ||= Remote.new(@store)
    end

    def cache
      @cache ||= Cache.new(@store)
    end
  end
end
