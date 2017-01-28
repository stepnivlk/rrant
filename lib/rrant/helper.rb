module Rrant
  module Helper
    def image_blank?(rant)
      rant['attached_image'].nil? || rant['attached_image'] == ''
    end

    def files_path
      File.expand_path('../../files/', File.dirname(__FILE__))
    end
  end
end
