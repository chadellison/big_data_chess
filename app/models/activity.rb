class Activity
  def self.create_abstraction(pieces)
    signature = ''
    pieces.each do |piece|
      signature += piece.piece_type + piece.valid_moves.size.to_s
    end

    AbstractionHelper.retrieve_abstraction('activity', signature.downcase)
  end
end
