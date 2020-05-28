class PieceAnalyzer
  def self.find_piece_value(piece_type)
    case piece_type.downcase
    when 'p' then 1
    when 'n' then 3
    when 'b' then 3
    when 'r' then 5
    when 'q' then 9
    when 'k' then 1
    end
  end
end
