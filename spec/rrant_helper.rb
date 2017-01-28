module RrantHelper
  def self.root_path
    File.expand_path('fixtures/', File.dirname(__FILE__))
  end

  def self.delete_root_path
    FileUtils.rm_rf(root_path + '/.rrant')
  end

  def self.fake_rant(id)
    {
      'id' => id,
      'text' => '640kb should be enough'
    }
  end
end
