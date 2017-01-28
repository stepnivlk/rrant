module RrantHelper
  def self.root_path
    File.expand_path('fixtures/', File.dirname(__FILE__))
  end

  def self.delete_root_path
    FileUtils.rm_rf(root_path + '/.rrant')
  end

  def self.fake_rant(id, viewed = false, image = false)
    rant = { 'id' => id,
             'text' => '640kb should be enough' }
    image_path = File.expand_path('../files/bill.jpg', File.dirname(__FILE__))

    rant.tap do |r|
      r['viewed_at'] = DateTime.now if viewed
      r['image'] = image_path if image
    end
  end

  def self.fake_placeholder
    { 'text' => 'No rants available :/' }
  end
end
