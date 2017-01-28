require 'rrant/cache'
require 'rrant/remote'

module Rrant
  class Store
    def initialize(options = nil)
      @options = options || Hash.new(false)
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
      @remote ||= Remote.new
    end

    def cache
      @cache ||= Cache.new(@offline)
    end
  end
end
