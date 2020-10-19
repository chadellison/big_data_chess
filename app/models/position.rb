class Position < ApplicationRecord
  def self.find_position(signature)
    position = CacheService.get(signature)

    if position.present?
      position
    else
      position = Position.find_by(signature: signature)
      CacheService.set(signature, position) if position.present?
      position
    end
  end

  def self.create_position(fen_notation)
    fen = fen_notation.to_fen
    signature = fen.board_string + fen.active

    current_position = Position.find_position(signature)

    if current_position.blank?
      current_position = Position.new({signature: signature})
    end
    current_position.handle_result(current_position, result)
    current_position
  end

  def update_results(result)
    case result
    when '1/2-1/2'
      draws += 1
    when '1-0'
      white_wins += 1
    when '0-1'
      black_wins += 1
    end
  end
end
