require 'catpix'

module Rrant
  # Public: Outputs rant hash, or serialized rant with image to the STDOUT.
  #
  # rant - Hash, rant to be outputed.
  # show_images - Boolean, when set we output attached image also.
  class Output
    def initialize(rant, show_images)
      @rant = rant
      @show_images = show_images
    end

    # Public: Returns rant as a hash.
    def in
      @rant
    end

    # Public: Prints serialzied rant to the STDOUT.
    def out
      puts_image
      puts @rant['text']
      puts footer
    end

    private

    # Private: Generates footer with coloring in this format:
    # [username][score][rant_url]
    def footer
      ''.tap do |text|
        text << "\n"
        text << "\e[37m[\e[0m#{@rant['user_username']}\e[37m][\e[0m"
        text << "#{@rant['score']}\e[37m][\e[0m"
        text << "#{build_address}\e[37m]\e[0m"
      end
    end

    # Wrapper around Catpix gem, prints image to terminal.
    def puts_image
      return unless @show_images
      return unless @rant['image']

      Catpix.print_image(@rant['image'],
                         resolution: 'low',
                         limit_x: 0.4,
                         limit_y: 0.4)
    end

    def build_address
      'https://www.devrant.io/'.tap do |url|
        url << "rants/#{@rant['id']}" if @rant['id']
      end
    end
  end
end
