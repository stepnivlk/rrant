require 'catpix'

module Rrant
  class Output
    def initialize(rant, images, show_images)
      @rant = rant
      @images = images
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

      path = @images + @rant['image']
      Catpix::print_image(path, resolution: 'low', limit_x: 0.5, limit_y: 0.5)
    end
  end
end
