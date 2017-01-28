module Rrant
  class Local
    def initialize(store)
      @unseen = false
      @store = store
    end

    def random
      return placeholder if @store.empty?
      rant = pick_random.tap { |rant| @store.touch(rant['id']) }
      return placeholder unless rant

      rant
    end

    def unseen(set)
      @unseen = set
      self
    end

    private

    def pick_random
      return @store.entities.sample unless @unseen

      @store.entities.reject { |rant| !rant['viewed_at'].nil? }.sample
    end

    def placeholder
      { 'text' => 'No rants available :/', 'image' => 'devrant.png' }
    end
  end
end
