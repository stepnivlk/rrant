module Rrant
  # Public: Contains helper methods meant to be included in other Classes.
  module Helper
    def image_blank?(rant)
      rant['attached_image'].nil? || rant['attached_image'] == ''
    end

    def files_path
      File.expand_path('../../files/', File.dirname(__FILE__))
    end

    def bill
      {
        'text'          => '80 rants should be enough.',
        'image'         => "#{files_path}/bill.jpg",
        'score'         => 80,
        'user_username' => 'Bill'
      }
    end
  end
end
