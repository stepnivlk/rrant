module Rrant
  class Local
    def initialize(store)
      @unseen = false
      @store = store
    end

    def random
      pick_random.tap { |rant| @store.touch(rant['id']) }
    end

    def pick_random
      return @store.entities.sample unless @unseen

      @store
        .entities
        .reject { |rant| rant['viewed_at'] != nil }
        .sample
    end

    def top
    end

    def unseen(set)
      @unseen = set
      self
    end
  end
end
