class AbstractionHelper
  def self.retrieve_abstraction(abstraction_type, signature)
    abstraction = CacheService.hget(abstraction_type, signature)

    if abstraction.present?
      abstraction
    else
      abstraction = {
        'signature' => signature,
        'white_wins' => 0,
        'black_wins' => 0,
        'draws' => 0,
        'type' => abstraction_type
      }
      CacheService.hset(abstraction_type, signature, abstraction)
      abstraction
    end
  end
end
