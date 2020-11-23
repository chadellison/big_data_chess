class Pin
  def self.create_abstraction(pieces)
    pinners = ['r', 'b', 'q']
    signature = ''
    pieces.each do |piece|
      if pinners.include?(piece.piece_type.downcase)
        pinned = find_pinned(pieces, piece.move_potential)
        signature += "#{piece.piece_type}-#{pinned.join}" if pinned.present?
      end
    end

    AbstractionHelper.retrieve_abstraction('pin', signature.downcase)
  end

  def self.find_pinned(pieces, moves)
    pieces.map do |piece|
      if moves.include?(piece.position)
        piece.piece_type
      else
        ''
      end
    end
  end
end
