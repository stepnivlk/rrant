require 'catpix'

module Rrant
  class Output
    def initialize(rant, show_images)
      @rant = rant
      @show_images = show_images
    end

    def in
      @rant
    end

    def out
      puts_image
      puts @rant['text']
    end

    private

    def puts_image
      return unless @show_images
      return unless @rant['image']

      Catpix.print_image(@rant['image'],
                         resolution: 'low',
                         limit_x: 0.4,
                         limit_y: 0.4)
    end
  end
end
