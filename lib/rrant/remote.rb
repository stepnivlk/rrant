module Rrant
  class Remote
    attr_reader :rants

    def initialize(store)
      @store = store
      @stored_ids = @store.ids
    end

    def save
      fetch_rants
      filter_rants
      @store.add(@rants)
    end

    def filter_rants
      @rants = @rants.reject do |rant|
        @stored_ids.include?(rant['id'])
      end
    end

    def fetch_rants
      response = HTTParty.get('https://www.devrant.io/api/devrant/rants?app=3&sort=algo')
      @rants = response['rants']
    end

    def fetch_image(rant)
      return if rant['attached_image'] == ''

      url = rant['attached_image']['url']
      download = open(url)
      IO.copy_stream(download, url.split('/')[-1])
    end
  end
end
