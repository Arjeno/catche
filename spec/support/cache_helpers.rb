class String
  def action_cached?
    Rails.cache.exist?("views/www.example.com#{self}")
  end
end