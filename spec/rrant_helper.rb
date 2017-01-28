module RrantHelper
  def self.root_path
    File.expand_path('fixtures/', File.dirname(__FILE__))
  end

  def self.delete_root_path
    FileUtils.rm_rf(root_path + '/.rrant')
  end

  def self.fake_rant(id, viewed = false)
    {
      'id' => id,
      'text' => '640kb should be enough'
    }.tap { |rant| rant['viewed_at'] = DateTime.now if viewed }
  end

  def self.fake_placeholder
    { 'text' => 'No rants available :/' }
  end
end
