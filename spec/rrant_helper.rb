module RrantHelper
  def self.root_path
    File.expand_path('fixtures/', File.dirname(__FILE__))
  end

  def self.delete_root_path
    FileUtils.rm_rf(root_path)
  end
end
