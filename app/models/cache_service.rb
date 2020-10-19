class CacheService
  def self.get(key)
    json = REDIS.get(key)
    if json.present?
      JSON.parse(json)
    end
  end

  def self.set(key, value)
    REDIS.set(key, value.to_json)
  end
end
