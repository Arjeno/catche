class String
  def action_cached?
    Rails.cache.exist?("views/www.example.com#{self}")
  end
  def page_cached?
    File.exists?(ActionController::Base.send(:page_cache_path, self))
  end
end