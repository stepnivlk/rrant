module Rrant
  class Remote
    attr_reader :rants

    MAX_CYCLE = 10
    SLEEP = 0.2

    def initialize(store, amount = MAX_CYCLE)
      @rants = []
      @store = store
      @amount = amount
    end

    def save
      build_rants
      @store.add(@rants)
    end

    # private

    def build_rants(cycle = 0)
      fetch_rants(cycle)
      filter_rants
      p @rants
      sleep SLEEP
      return unless fetch_allowed?.call(cycle)

      build_rants(cycle + 1)
    end

    def fetch_allowed?
      ->(cycle) { @rants.size < @amount && cycle < MAX_CYCLE }
    end

    def filter_rants
      stored_ids = @store.ids

      @rants = @rants.reject do |rant|
        stored_ids.include?(rant['id'])
      end
    end

    def fetch_rants(skip = 0)
      p skip
      skip = skip == 0 ? '' : "&skip=#{skip * 20}"
      response = HTTParty.get("https://www.devrant.io/api/devrant/rants?app=3&sort=algo#{skip}")
      @rants = @rants + response['rants']
    end

    def fetch_image(rant)
      return if rant['attached_image'] == ''

      url = rant['attached_image']['url']
      download = open(url)
      IO.copy_stream(download, url.split('/')[-1])
    end
  end
end
