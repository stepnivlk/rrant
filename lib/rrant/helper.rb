module Rrant
  module Helper
    def image_blank?(rant)
      rant['attached_image'].nil? || rant['attached_image'] == ''
    end
  end
end
