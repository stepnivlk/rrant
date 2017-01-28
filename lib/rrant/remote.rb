module Rrant
  class Remote
    def initialize
      @remote = nil
    end

    def fetch
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
