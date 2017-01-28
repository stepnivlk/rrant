module Rrant
  class Cache
    def initialize(offline = false)
      @offline = offline
      @order = :algo
      @cache = PStore.new('store.pstore')
    end

    def random
    end

    def find(id)
      rant = find_cached(id)
      return rant if @offline

      !rant && @remote.find(id)
    end

    def list(amount)
    end

    def unseen(set)
      @unseen = set
      self
    end

    def order(sort)
      @order = sort
      self
    end

    def with(remote)
      @remote = remote unless @offline
      self
    end

    def find_cached(id)
      @cache.transaction do
        @cache[:rants].find { |rant| rant['id'] == id }
      end
    end
  end
end
